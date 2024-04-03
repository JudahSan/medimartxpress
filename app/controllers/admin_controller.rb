class AdminController < ApplicationController
  layout 'admin'
  # require user authentication
  before_action :authenticate_admin!
def index

end
end