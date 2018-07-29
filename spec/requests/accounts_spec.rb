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

  describe "PUT /accounts/:id/" do
    let(:account) { create(:account, name: "Foo", credit_limit: 100) }
    let(:updated_attributes) { { name: "Bar", credit_limit: 500} }
    
    it "updates an Account" do
      put "/accounts/#{account.id}", params: { account: updated_attributes }
      expect(response).to redirect_to(accounts_path)
      account.reload
      expect(account.name).to eq "Bar"
      expect(account.credit_limit).to eq 500
    end
  end
end