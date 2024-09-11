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
    line_items = build_line_items(params[:cart])
    Rails.logger.debug { "line_items: #{line_items}" }

    session = create_checkout_session(line_items)

    render json: { url: session.url }
  end

  private

  def initialize_stripe
    stripe_secret_key = Rails.application.credentials.dig(:stripe, :secret_key)
    Stripe.api_key = stripe_secret_key
  end

  def build_line_items(cart)
    cart.map do |item|
      product = Product.find(item["id"])
      {
        price_data: {
          product_data: {
            name:        item["name"],
            metadata:    {
              product_id: product.id
            },
            currency:    "kes",
            unit_amount: item["price"].to_i
          }
        }
      }
    end
  end

  def create_checkout_session(line_items)
    Stripe::Checkout::Session.create(
      mode:                        "payment",
      line_items:,
      success_url:                 "http://localhost:3000/success",
      cancel_url:                  "http://localhost:3000/cancel",
      shipping_address_collection: {
        allowed_countries: %w[JP KE]
      }
    )
  end
end
