# frozen_string_literal: true

# CheckoutsController handles the checkout process for the application.
#
# This controller is responsible for managing the checkout flow using Stripe's
# API. It initializes Stripe with the secret key, builds line items from the
# cart provided by the user, creates a Checkout session with those line items,
# and returns the session URL for redirection. The session allows users to
# complete their purchase securely.
class CheckoutsController < ApplicationController
  def create
    initialize_stripe

    if params[:cart].blank?
      render json: { error: "Cart is empty or missing." }, status: :bad_request
      return
    end

    line_items = build_line_items(params[:cart])
    return unless line_items

    session = create_checkout_session(line_items)
    render json: { url: session.url }
  end

  private

  # Initialize Stripe API key
  def initialize_stripe
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
  end

  # Build line items for Stripe Checkout from the cart
  def build_line_items(cart)
    line_items = cart.map do |item|
      build_item_line(item)
    end

    line_items.compact.presence || render_error("No valid line items.", :unprocessable_entity)
  end

  # Build individual line item for Stripe
  def build_item_line(item)
    product = find_product(item)
    return unless product

    product_stock = find_product_stock(product)
    return unless product_stock

    return check_stock(product, product_stock, item) unless valid_stock?(product_stock, item)

    build_stripe_line_item(item, product, product_stock)
  end

  # Find a product by ID
  def find_product(item)
    Product.find_by(id: item["id"]).tap do |product|
      render_error("Product with ID #{item['id']} not found.", :not_found) unless product
    end
  end

  # Find product stock
  def find_product_stock(product)
    product.stocks.first.tap do |product_stock|
      render_error("No stock found for product #{product.name}.", :not_found) unless product_stock
    end
  end

  # Check stock availability
  def check_stock(product, product_stock, item)
    return if product_stock.amount >= item["quantity"].to_i

    render_error(
      "Limited stock for #{product.name}. Only #{product_stock.amount} remain.",
      :bad_request
    )
  end

  # Validate stock against the requested quantity
  def valid_stock?(product_stock, item)
    product_stock.amount >= item["quantity"].to_i
  end

  # Build a line item for Stripe
  def build_stripe_line_item(item, product, product_stock)
    {
      quantity:   item["quantity"].to_i,
      price_data: {
        currency:     default_currency,
        product_data: {
          name:     item["name"],
          metadata: {
            product_id:       product.id,
            product_stock_id: product_stock.id
          }
        },
        unit_amount:  item["price"].to_i
      }
    }
  end

  # Create a Stripe Checkout session
  def create_checkout_session(line_items)
    Stripe::Checkout::Session.create(
      mode:                        "payment",
      line_items:,
      success_url:,
      cancel_url:,
      shipping_address_collection: { allowed_countries: %w[JP KE US] }
    )
  end

  # Handle errors with rendering JSON and status
  def render_error(message, status)
    render(json: { error: message }, status:)
    nil
  end

  # Define the success URL for checkout
  def success_url
    "#{root_url}success"
  end

  # Define the cancel URL for checkout
  def cancel_url
    "#{root_url}cancel"
  end

  def success
    render :success
  end

  def cancel
    render :cancel
  end

  # Set default currency (can be refactored based on region, user preferences, etc.)
  def default_currency
    "kes"
  end
end
