FactoryBot.define do
  factory :account, aliases: [:credit_card_account] do
    name { Faker::Bank.name }
    credit_limit { Faker::Commerce.price(100..10000) }
    account_type "Credit Card"
    enabled true

    factory :checking_account do
      credit_limit nil
      account_type "Checking"
    end
  end
end