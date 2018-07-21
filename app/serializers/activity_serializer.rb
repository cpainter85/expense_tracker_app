class ActivitySerializer < ApplicationSerializer
  attributes  :transaction_date,
              :merchant,
              :description,
              :cleared,
              :amount

  belongs_to :account
  belongs_to :category
end