# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Category, type: :model do
  it "is valid with valid attributes" do
    category = Category.new(name: "Supplements", description: "All medical supplements")
    expect(category).to be_valid
  end

  it "is not valid without a name" do
    category = Category.new(name: nil, description: "Description")
    expect(category).to_not be_valid
  end

  it "is not valid without a description" do
    category = Category.new(name: "First Aid", description: nil)
    expect(category).to_not be_valid
  end

  it "has many products" do
    association = described_class.reflect_on_association(:products)
    expect(association.macro).to eq(:has_many)
  end
end
