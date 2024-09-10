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
require "rails_helper"

RSpec.describe OrderProduct, type: :model do
  let(:product) { create(:product) }
  let(:order) { create(:order) }

  it "is valid with valid attributes" do
    order_product = OrderProduct.new(product:, order:, size: "M", quantity: 2)
    expect(order_product).to be_valid
  end

  it "belongs to a product" do
    association = described_class.reflect_on_association(:product)
    expect(association.macro).to eq(:belongs_to)
  end

  it "belongs to a order" do
    association = described_class.reflect_on_association(:order)
    expect(association.macro).to eq(:belongs_to)
  end
end
