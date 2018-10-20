class Activity < ApplicationRecord
  include ElasticsearchActivity

  after_commit -> { __elasticsearch__.index_document }, on: [:create, :update]
  after_commit -> { __elasticsearch__.delete_document }, on: :destroy

  belongs_to :account
  belongs_to :category

  def self.merchant_autocomplete(args)
    if args[:term].present?
      request = {
        query: {
          match: { merchant: args[:term] }
        },
        _source: :merchant
      }

      response = Activity.search(request)

      response.per(5).results.map(&:_source).map(&:merchant)
    else
      []
    end
  end
end