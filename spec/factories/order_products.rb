FactoryBot.define do
  factory :order_product do
    association :product
    association :order
    size { "M" }
    quantity { 2 }
  end
end
