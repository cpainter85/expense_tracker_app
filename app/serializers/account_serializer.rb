class AccountSerializer < ApplicationSerializer
  attributes :name, :enabled, :credit_limit, :account_type
end