class ThemeController < ApplicationController
  def index
    cookies[:theme] = params[:theme]
    redirect_to(request.referrer || root_path)
  end
end