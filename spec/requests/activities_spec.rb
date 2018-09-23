require "rails_helper"

describe "Activties" do
  describe "POST /activities" do
    let(:account) { create(:account) }
    let(:category) { create(:category) }
    let(:activity_attributes) { FactoryBot.attributes_for(:activity, account_id: account.id, category_id: category.id) }
    
    it "creates a new Activity" do
      post "/accounts/#{account.id}/activities", params: { activity: activity_attributes }
      expect(response).to redirect_to(account_path(account))
      activity = Activity.last
      expect(activity.account_id).to eq account.id
      expect(activity.category_id).to eq category.id
      expect(activity.transaction_date.to_s).to eq activity_attributes[:transaction_date].strftime("%Y-%m-%d")
      expect(activity.amount.to_s).to eq activity_attributes[:amount].to_s
      expect(activity.merchant).to eq activity_attributes[:merchant]
      expect(activity.description).to eq activity_attributes[:description]
      expect(activity.cleared).to eq activity_attributes[:cleared]
    end

    context "a required attribute is missing" do
      it "does NOT create a new Activity" do
        expect { post "/accounts/#{account.id}/activities", params: { activity: {category_id: nil} } }
          .to_not change{Activity.count}
      end
    end
  end
end