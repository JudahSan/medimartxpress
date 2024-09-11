# frozen_string_literal: true

# Handles actions related to product categories.
class CategoriesController < ApplicationController
  # Displays a specific category and its associated products.
  #
  # Finds the category by ID and retrieves all products associated with it.
  #
  # @return [void]
  def show
    @category = Category.find(params[:id])
    @products = @category.products
  end
end
