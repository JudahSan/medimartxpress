FactoryBot.define do
  factory :order do
    customer_email { "customer@email.com" }
    fulfilled { false }
    total { 100 }
    address { "123 Test St" }
  end
end
