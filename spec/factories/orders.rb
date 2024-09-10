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
FactoryBot.define do
  factory :order do
    customer_email { "customer@email.com" }
    fulfilled { false }
    total { 100 }
    address { "123 Test St" }
  end
end
