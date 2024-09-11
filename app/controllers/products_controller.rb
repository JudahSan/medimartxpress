# frozen_string_literal: true

# ProductsController handles requests related to displaying individual products.
# This controller includes actions for showing product details based on the product's
# ID, retrieving the relevant product from the database and making it available
# for display in the view.
class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end
end
