# == Schema Information
#
# Table name: orders
#
#  id             :bigint           not null, primary key
#  address        :string
#  customer_email :string
#  fulfilled      :boolean
#  total          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  it "is valid with valid attributes" do
    order = Order.new(customer_email: "customer@example.com", total: 100, fulfilled: false, address: "123 Street")
    expect(order).to be_valid
  end

  it "is not valid without a customer email" do
    order = Order.new(customer_email: nil, total: 100, fulfilled: false, address: "123 Street")
    expect(order).to_not be_valid
  end

  it "has many order_products" do
    association = described_class.reflect_on_association(:order_products)
    expect(association.macro).to eq(:has_many)
  end
end
