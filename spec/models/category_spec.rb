require "rails_helper"

describe Category do
  describe "relationships" do
    it { should have_many(:activities) }
  end

  describe '#update_activity_documents' do
    let(:category) { create(:category) }
    let!(:activities) { create_list(:activity, 3, category: category) }

    it "calls Activity.bulk_update_activity_documents with activities belonging to the category and the serialized category" do
      expect(Activity).to receive(:bulk_update_activity_documents)
        .with(activity_ids: activities.pluck(:id), data: { category: CategorySerializer.new(category).as_json })

      category.update_activity_documents
    end
  end
end