FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    description { "Product Description" }
    price {100 }
    association :category
  end
end
