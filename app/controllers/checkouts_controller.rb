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

    # Ensure the cart param exists and isn't empty
    unless params[:cart].present?
      return render json: { error: 'Cart is empty or missing.' }, status: 400
    end

    line_items = build_line_items(params[:cart])
    return unless line_items # Avoid further execution if stock issues occurred

    session = create_checkout_session(line_items)

    render json: { url: session.url }
  end

  private

  def initialize_stripe
    stripe_secret_key = Rails.application.credentials.dig(:stripe, :secret_key)
    Stripe.api_key = stripe_secret_key
  end

  # Builds line items for Stripe Checkout from the cart
  def build_line_items(cart)
    cart.map do |item|
      product = Product.find(item["id"])
      unless product
        render json: { error: "Product with ID #{item['id']} not found." }, status: 404
        return
      end

      # Get product stock (adjust based on your model associations)
      product_stock = product.stocks.first # Ensure this association exists

      unless product_stock
        render json: { error: "No stock found for product #{product.name}." }, status: 404
        return
      end

      if product_stock.amount < item["quantity"].to_i
        render json: { error: "Limited stock for #{product.name}. Only #{product_stock.amount} remain." }, status: 400
        return
      end

      # Create line item for Stripe
      {
        quantity: item["quantity"].to_i,
        price_data: {
          currency: default_currency,
          product_data: {
            # name: product.name,
            name: item["name"],
            metadata: {
              product_id: product.id, product_stock_id: product_stock.id
            }
          },
          unit_amount: item["price"].to_i * 100
        }
      }
    end
  end

  def create_checkout_session(line_items)
    stripe_session = Stripe::Checkout::Session.create(
      mode: 'payment',
      line_items: line_items,
      success_url: success_url,
      cancel_url: cancel_url,
      shipping_address_collection: {
        allowed_countries: %w[JP KE US]
      }
    )
    stripe_session
  end

  # Refactor URLs into private methods to avoid hardcoding
  def success_url
    root_url + "success"
  end

  def cancel_url
    root_url + "cancel"
  end

  # Set default currency (can be refactored based on region, user preferences, etc.)
  def default_currency
    "kes"
  end
end
