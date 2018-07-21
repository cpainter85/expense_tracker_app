FactoryBot.define do
  factory :activity, aliases: [:cleared_activity] do
    account
    category
    transaction_date { 2.days.ago }
    cleared { true }
    merchant { Faker::Company.name }
    description { Faker::Commerce.product_name }
    amount { Faker::Commerce.price }
  end
end