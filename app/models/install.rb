# frozen_string_literal: true

# The Install model manages the authentication for the Install entity.
# It includes devise modules for user authentication and account management.
class Install < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
