# == Schema Information
#
# Table name: order_products
#
#  id         :bigint           not null, primary key
#  product_id :bigint           not null
#  order_id   :bigint           not null
#  size       :string
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class OrderProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
