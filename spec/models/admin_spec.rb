# == Schema Information
#
# Table name: admins
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#
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
