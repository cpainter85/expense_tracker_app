class Activity < ApplicationRecord
  include ElasticsearchActivity

  belongs_to :account
  belongs_to :category
end