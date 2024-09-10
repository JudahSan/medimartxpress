# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { "admin@example.com" }
    password { "password123" }
  end
end
