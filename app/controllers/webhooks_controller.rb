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
  def stripe
    initialize_stripe
    event = verify_stripe_signature(request.body.read, request.env["HTTP_STRIPE_SIGNATURE"])

    return if event.nil? # Stop execution if signature verification failed

    handle_event(event)

    render json: { message: "success" }
  end

  private

  # Initializes Stripe API key
  def initialize_stripe
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
  end

  # Verifies the signature of the incoming Stripe webhook
  #
  # This method checks the signature header sent by Stripe to ensure the
  # integrity and authenticity of the webhook event. If the signature is valid,
  # the event is returned. If it fails, a JSON error response is rendered and
  # the method returns `nil`.
  def verify_stripe_signature(payload, sig_header)
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)
    Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
  rescue JSON::ParserError => e
    Rails.logger.error "Webhook JSON parse error: #{e.message}"
    render json: { error: "Invalid payload" }, status: :bad_request
    nil
  rescue Stripe::SignatureVerificationError => e
    Rails.logger.error "Webhook signature verification failed: #{e.message}"
    render json: { error: "Unauthorized" }, status: :bad_request
    nil
  end

  # Handles different types of Stripe webhook events
  def handle_event(event)
    case event.type
    when "checkout.session.completed"
      process_checkout_completed(event.data.object)
    else
      Rails.logger.warn "Unhandled event type: #{event.type}"
    end
  end

  # Processes a successful checkout session completion
  #
  # This method handles the 'checkout.session.completed' event from Stripe.
  # It retrieves session details, creates a new order, and processes the line
  # items (updating stock and associating products with the order).
  def process_checkout_completed(session)
    address = format_address(session["shipping_details"])
    order = Order.create!(
      customer_email: session["customer_details"]["email"],
      total:          session["amount_total"],
      address:,
      fulfilled:      false
    )

    process_line_items(order, session.id)
  end

  # Formats shipping address from session details
  def format_address(shipping_details)
    if shipping_details
      "#{shipping_details['address']['line1']} #{shipping_details['address']['city']}, " \
        "#{shipping_details['address']['state']} #{shipping_details['address']['postal_code']}"
    else
      ""
    end
  end

  # Retrieves and processes line items from the session
  def process_line_items(order, session_id)
    full_session = Stripe::Checkout::Session.retrieve(id: session_id, expand: ["line_items"])
    line_items = full_session.line_items

    line_items["data"].each do |item|
      product_metadata = retrieve_product_metadata(item)
      create_order_product(order, item, product_metadata)
      decrement_stock(product_metadata, item["quantity"])
    end
  end

  # Retrieves product metadata from Stripe
  def retrieve_product_metadata(item)
    product = Stripe::Product.retrieve(item["price"]["product"])
    {
      product_id:       product["metadata"]["product_id"].to_i,
      product_stock_id: product["metadata"]["product_stock_id"].to_i,
      size:             product["metadata"]["size"]
    }
  end

  # Creates an OrderProduct entry
  def create_order_product(order, item, metadata)
    OrderProduct.create!(
      order:,
      product_id: metadata[:product_id],
      quantity:   item["quantity"],
      size:       metadata[:size]
    )
  end

  # Decreases stock based on purchased quantity
  def decrement_stock(metadata, quantity)
    stock = Stock.find(metadata[:product_stock_id])
    stock.update!(amount: stock.amount - quantity) if stock.amount >= quantity
  end
end
