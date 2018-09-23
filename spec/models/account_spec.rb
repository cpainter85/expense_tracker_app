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

    context "Account has NO activities" do
      before :each do
        account.activities.destroy_all
      end

      it "does nothing" do
        expect(Activity).not_to receive(:bulk_update_activity_documents)
        account.update_activity_documents
      end
    end
  end

  describe '#get_activities' do
    let(:account) { create(:account) }
    let(:response_double) { double }

    before :each do
      allow(response_double).to receive(:per).with(25)
    end

    it "queries Elasticsearch for all activities belonging to the account" do
      expect(Activity).to receive(:search).with({ 
        query: {
          bool: {
            filter: [ { term: { "account.id" => account.id } } ]
          }
        },
        sort: [{ transaction_date: :desc } ],
        aggs: {
          total_balance: {
            sum: { field: :amount }
          }
        }
      }).and_return(response_double)

      expect(response_double).to receive(:page).with(1).and_return(response_double)

      account.get_activities
    end

    context "given a page argument" do
      it "calls page on the response object with the given page number" do
        allow(Activity).to receive(:search).and_return(response_double)

        expect(response_double).to receive(:page).with(2).and_return(response_double)

        account.get_activities(page: 2)
      end
    end
  end
end