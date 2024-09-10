require 'rails_helper'

RSpec.describe OrderProduct, type: :model do
  let(:product) { create(:product) }
  let(:order) { create(:order) }

  it "is valid with valid attributes" do
    order_product = OrderProduct.new(product: product, order: order, size: "M", quantity: 2)
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
