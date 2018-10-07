class Activity < ApplicationRecord
  include ElasticsearchActivity

  after_commit -> { __elasticsearch__.index_document }, on: [:create, :update]
  after_commit -> { __elasticsearch__.delete_document }, on: :destroy

  belongs_to :account
  belongs_to :category
end