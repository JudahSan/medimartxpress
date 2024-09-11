# frozen_string_literal: true

# == Schema Information
#
# Table name: order_products
#
#  id         :bigint           not null, primary key
#  quantity   :integer
#  size       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_order_products_on_order_id    (order_id)
#  index_order_products_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (product_id => products.id)
#
class OrderProduct < ApplicationRecord
  belongs_to :product
  belongs_to :order
end
