# frozen_string_literal: true

class ThemeController < ApplicationController
  def index
    cookies[:theme] = params[:theme]
    redirect_to(request.referer || root_path)
  end
end
