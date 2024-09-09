class CheckoutsController < ApplicationController
  def create
    stripe_secret_key = Rails.application.credentials.dig(:stripe, :secret_key)
    Stripe.api_key = stripe_secret_key
    cart = params[:cart]
    line_items = cart.map do |item|
      product = Product.find(item["id"])
      {
        price_data: {
          product_data: {
            name: item["name"],
            metadata: {
              product_id: product.id
            },
            currency: 'kes',
            unit_amount: item["price"].to_i
          }
        }
      }
    end
    puts "line_items: #{line_items}"

    # Checkout session
    session = Stripe::Checkout::Session.create(
      mode: "payment",
      line_items: line_items,
      success_url: "http://localhost:3000/success",
      cancel_url: "http://localhost:3000/cancel",
      shipping_address_collection: {
        allowed_countries: ['JP', 'KE']
      }
    )

    render json: { url: session.url }
  end
end
