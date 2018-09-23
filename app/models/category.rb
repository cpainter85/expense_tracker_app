class Category < ApplicationRecord
  has_many :activities

  after_commit :update_activity_documents, on: :update

  def update_activity_documents
    if activities.size > 0
      Activity.bulk_update_activity_documents(
        activity_ids: activities.pluck(:id),
        data: { category: CategorySerializer.new(self).as_json }
      )
    end
  end
end