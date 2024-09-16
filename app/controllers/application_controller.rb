# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Include it in the controllers (e.g. application_controller.rb)
  include Pagy::Backend
end
