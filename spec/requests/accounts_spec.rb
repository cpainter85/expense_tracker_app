require "rails_helper"

describe "Accounts" do
  describe "POST /accounts" do
    let(:account_attributes) { FactoryBot.attributes_for(:account).with_indifferent_access }
    
    it "creates a new Account" do
      post "/accounts", params: { account: account_attributes }
      expect(response).to redirect_to(accounts_path)
      expect(Account.last.attributes).to include(account_attributes)
    end
  end
end