# frozen_string_literal: true

# HomeController handles requests related to the home page of the application.
# This controller includes actions for displaying the main page, including a selection
# of main categories. It retrieves a limited set of categories to display on the home
# page and prepares them for rendering in the view.
class HomeController < ApplicationController
  def index
    @main_categories = Category.take(4)
  end

  # def randon_banner_image
  #   images = Dir.glob(Rails.root.join('app', 'assets', 'images'))
  # end
end
