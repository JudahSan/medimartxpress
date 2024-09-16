# frozen_string_literal: true

# ThemeController handles requests related to user theme preferences. This controller
# includes actions for setting and managing the user's theme, which is stored in cookies.
# It provides functionality to update the theme based on user input and redirect
# back to the referring page or the root path.
class ThemeController < ApplicationController
  def index
    cookies[:theme] = params[:theme]
    redirect_to(request.referer || root_path)
  end
end
