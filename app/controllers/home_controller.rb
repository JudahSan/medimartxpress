class HomeController < ApplicationController
  def index
    @main_categories = Category.take(4)
  end

  # def randon_banner_image
  #   images = Dir.glob(Rails.root.join('app', 'assets', 'images'))
  # end
end
