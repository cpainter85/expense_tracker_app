class Account < ApplicationRecord
  has_many :activities

  after_commit :update_activity_documents, on: :update
  
  ACCOUNT_TYPES = ["Checking", "Credit Card"]

  def update_activity_documents
    Activity.bulk_update_activity_documents(
      activity_ids: activities.pluck(:id),
      data: { account: AccountSerializer.new(self).as_json }
    )
  end
end