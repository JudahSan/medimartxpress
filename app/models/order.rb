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
  has_many :order_products
end
