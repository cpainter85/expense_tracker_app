class Account < ApplicationRecord
  has_many :activities
  
  ACCOUNT_TYPES = ["Checking", "Credit Card"]
end