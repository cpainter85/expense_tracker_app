require "rails_helper"

describe Account do
  describe "relationships" do
    it { should have_many(:activities) }
  end

  describe '#update_activity_documents' do
    let(:account) { create(:account) }
    let!(:activities) { create_list(:activity, 3, account: account) }

    it "calls Activity.bulk_update_activity_documents with activities belonging to the account and the serialized account" do
      expect(Activity).to receive(:bulk_update_activity_documents)
        .with(activity_ids: activities.pluck(:id), data: { account: AccountSerializer.new(account).as_json })

      account.update_activity_documents
    end
  end
end