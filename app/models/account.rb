class Account < ApplicationRecord
  has_many :activities

  after_commit :update_activity_documents, on: :update
  
  ACCOUNT_TYPES = ["Checking", "Credit Card"]

  def update_activity_documents
    if activities.size > 0
      Activity.bulk_update_activity_documents(
        activity_ids: activities.pluck(:id),
        data: { account: AccountSerializer.new(self).as_json }
      )
    end
  end

  def get_activities(args={})
    page = args[:page] || 1

    response = Activity.search({ 
      query: {
        bool: {
          filter: [ { term: { "account.id" => self.id } } ]
        }
      },
      sort: [{ transaction_date: :desc } ],
      aggs: {
        total_balance: {
          sum: { field: :amount }
        }
      }
    })

    response.page(page).per(25)
  end
end