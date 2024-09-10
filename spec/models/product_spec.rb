require 'rails_helper'

RSpec.describe Product, type: :model do
  it "is valid with valid attributes" do
    category = Category.create(name: "Supplements", description: "All medical supplements")
    product = Product.new(name: "Vitamin D test", description: "A Vitamin D test supplement", price: 1000, category: category)
    expect(product).to be_valid
  end

  it "is not valid without a name" do
    category = Category.create(name: "Supplements", description: "All medical supplements")
    product = Product.new(name: nil, description: "A Vitamin D test supplement", price: 1000, category: category)
    expect(product).to_not be_valid
  end

  it "belongs to a category" do
    association = described_class.reflect_on_association(:category)
    expect(association.macro).to eq(:belongs_to)
  end

  it "has may stocks" do
    association = described_class.reflect_on_association(:stocks)
    expect(association.macro).to eq(:has_many)
  end

  it "has many order_products" do
    association = described_class.reflect_on_association(:order_products)
    expect(association.macro).to eq(:has_many)
  end

  # TODO: Test thumbnail
  # it "returns images as thumbnails" do
  #     product = Product.create(name: "Laptop", description: "A high-performance laptop", price: 1000, category: Category.create(name: "Electronics", description: "All electronic items"))
  #     # Assuming you have a test image attached to the product
  #     # product.images.attach(io: File.open('path/to/image.jpg'), filename: 'image.jpg', content_type: 'image/jpeg')
  #     # expect(product.images_as_thumbnail).to be_present
  #   end

end
