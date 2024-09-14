# frozen_string_literal: true

# WebhooksController handles incoming webhook events from Stripe.
#
# This controller processes webhook events such as checkout session completions.
# It verifies the webhook signature, processes the event payload, and updates
# the application accordingly (e.g., creates an order and adjusts stock).
class WebhooksController < ApplicationController
  # Disable CSRF protection for webhooks since Stripe can't provide CSRF tokens
  skip_forgery_protection

  # Processes incoming Stripe webhook events
  #
  # This action handles Stripe webhook events sent to the /webhooks/stripe
  # endpoint. It verifies the signature of the incoming request, checks the
  # event type, and performs the appropriate action based on the event.
  #
  # Supported events:
  #   - checkout.session.completed: Creates an order and processes line items
  #
  # On successful processing of the webhook, a JSON response with a success
  # message is returned. If an error occurs (e.g., invalid signature, parsing
  # error), a 400 response is sent back to Stripe.
  #
  # Example:
  #   POST /webhooks/stripe
  #
  def stripe
    initialize_stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    event = verify_stripe_signature(payload, sig_header)

    return if event.nil? # Stop execution if signature verification failed

    case event.type
    when "checkout.session.completed"
      process_checkout_completed(event.data.object)
    else
      # Log any unhandled event types
      Rails.logger.warn "Unhandled event type: #{event.type}"
    end

    # Respond with success to Stripe
    render json: { message: "success" }
  end

  private

  # Initializes Stripe API key
  #
  # This method fetches the Stripe secret key from the application's credentials
  # and assigns it to the Stripe API.
  #
  # Example:
  #   Stripe.api_key = stripe_secret_key
  def initialize_stripe
    stripe_secret_key = Rails.application.credentials.dig(:stripe, :secret_key)
    Stripe.api_key = stripe_secret_key
  end

  # Verifies the signature of the incoming Stripe webhook
  #
  # This method checks the signature header sent by Stripe to ensure the
  # integrity and authenticity of the webhook event. If the signature is valid,
  # the event is returned. If it fails, a JSON error response is rendered and
  # the method returns `nil`.
  #
  # Params:
  # +payload+:: the raw JSON payload sent by Stripe
  # +sig_header+:: the signature header (HTTP_STRIPE_SIGNATURE) sent by Stripe
  #
  # Returns:
  # - Stripe event object if the signature is valid
  # - Nil if the signature verification fails
  #
  # Example:
  #   event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
  def verify_stripe_signature(payload, sig_header)
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)
    Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
  rescue JSON::ParserError => e
    # Log JSON parsing errors
    Rails.logger.error "Webhook JSON parse error: #{e.message}"
    render json: { error: "Invalid payload" }, status: :bad_request
    nil
  rescue Stripe::SignatureVerificationError => e
    # Log signature verification failures
    Rails.logger.error "Webhook signature verification failed: #{e.message}"
    render json: { error: "Unauthorized" }, status: :bad_request
    nil
  end

  # Processes a successful checkout session completion
  #
  # This method handles the 'checkout.session.completed' event from Stripe.
  # It retrieves session details, creates a new order, and processes the line
  # items (updating stock and associating products with the order).
  #
  # Params:
  # +session+:: the checkout session object sent by Stripe
  #
  # Example:
  #   process_checkout_completed(session)
  def process_checkout_completed(session)
    shipping_details = session["shipping_details"]
    address = format_address(shipping_details)

    # Create a new order in the system
    order = Order.create!(
      customer_email: session["customer_details"]["email"],
      total: session["amount_total"],
      address:,
      fulfilled: false
    )

    # Process the line items of the order
    process_line_items(order, session.id)
  end

  # Formats shipping address
  #
  # This method formats the shipping address from the session's shipping details.
  # If no shipping details are present, it returns an empty string.
  #
  # Params:
  # +shipping_details+:: shipping information from the session
  #
  # Returns:
  # - Formatted address as a string
  #
  # Example:
  #   address = "#{shipping_details['line1']} #{shipping_details['city']}, ..."
  def format_address(shipping_details)
    if shipping_details
      "#{shipping_details["address"]["line1"]} #{shipping_details["address"]["city"]}, #{shipping_details["address"]["state"]} #{shipping_details["address"]["postal_code"]}"
    else
      ""
    end
  end

  # Retrieves and processes line items from the session
  #
  # This method retrieves the expanded line items from the Stripe session and
  # creates associated `OrderProduct` records for each item. It also decrements
  # the stock based on the quantities purchased.
  #
  # Params:
  # +order+:: the order to which the line items belong
  # +session_id+:: the ID of the Stripe checkout session
  #
  # Example:
  #   process_line_items(order, session_id)
  def process_line_items(order, session_id)
    full_session = Stripe::Checkout::Session.retrieve(
      id: session_id,
      expand: ["line_items"]
    )
    line_items = full_session.line_items

    line_items["data"].each do |item|
      product_metadata = retrieve_product_metadata(item)
      create_order_product(order, item, product_metadata)
      decrement_stock(product_metadata, item["quantity"])
    end
  end

  # Retrieves product metadata from Stripe
  #
  # This method retrieves the product metadata from Stripe for each line item.
  # The metadata includes the product ID, product stock ID, and size.
  #
  # Params:
  # +item+:: the line item object from Stripe
  #
  # Returns:
  # - A hash containing the product metadata (product ID, stock ID, size)
  #
  # Example:
  #   metadata = retrieve_product_metadata(item)
  def retrieve_product_metadata(item)
    product = Stripe::Product.retrieve(item["price"]["product"])
    {
      product_id: product["metadata"]["product_id"].to_i,
      product_stock_id: product["metadata"]["product_stock_id"].to_i,
      size: product["metadata"]["size"]
    }
  end

  # Creates an OrderProduct entry
  #
  # This method creates a record associating the order and the purchased product.
  #
  # Params:
  # +order+:: the order to which the product belongs
  # +item+:: the line item object from Stripe
  # +metadata+:: a hash containing product metadata
  #
  # Example:
  #   create_order_product(order, item, metadata)
  def create_order_product(order, item, metadata)
    OrderProduct.create!(
      order:,
      product_id: metadata[:product_id],
      quantity: item["quantity"],
      size: metadata[:size]
    )
  end

  # Decreases stock based on purchased quantity
  #
  # This method decrements the stock for a specific product stock ID based on
  # the quantity purchased, ensuring that stock levels are accurate after a
  # successful checkout.
  #
  # Params:
  # +metadata+:: a hash containing product metadata (including stock ID)
  # +quantity+:: the quantity purchased
  #
  # Example:
  #   decrement_stock(metadata, quantity)
  def decrement_stock(metadata, quantity)
    stock = Stock.find(metadata[:product_stock_id])
    stock.update!(amount: stock.amount - quantity) if stock.amount >= quantity
  end
end
