# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id             :bigint           not null, primary key
#  customer_email :string
#  fulfilled      :boolean
#  total          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  address        :string
#
class Order < ApplicationRecord
  validates :customer_email, presence: true
  has_many :order_products
end
