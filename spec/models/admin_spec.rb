require 'rails_helper'

RSpec.describe Admin, type: :model do
  it "is valid with valid attributes" do
    admin = Admin.new(email: "admin@example.com", password: "password")
    expect(admin).to be_valid
  end

  it "is not valid without an email" do
    admin = Admin.new(email: nil, password: "password")
    expect(admin).to_not be_valid
  end

  it "is not valid without password" do
    admin = Admin.new(email: "admin@example.com", password:nil)
  end
end
