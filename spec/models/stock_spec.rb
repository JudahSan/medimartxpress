require 'rails_helper'
RSpec.describe Stock, type: :model do
  it "is valid with valid attributes" do
    category = Category.create(name: "Supplements", description: "All medical supplements")
    product = Product.create(name: "Vitamin D test", description: "A Vitamin D test supplement", price: 1000, category: category)
    stock = Stock.new(product: product, amount: 10, size: "M")
    expect(stock).to be_valid
  end
end