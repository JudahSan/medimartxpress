# frozen_string_literal: true

# ApplicationRecord is the base class for all models in the application.
# It inherits from ActiveRecord::Base, and all models inherit from this class.
# This allows for shared functionality across all models.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
