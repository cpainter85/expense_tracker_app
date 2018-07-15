require "rails_helper"

describe AccountSerializer do
  let(:account) { create(:account) }
  subject(:account_json) { AccountSerializer.new(account).as_json }

  it "includes the id" do
    expect(account_json).to include(id: account.id)
  end

  it "includes the name" do
    expect(account_json).to include(name: account.name)
  end

  it "includes the enabled" do
    expect(account_json).to include(enabled: account.enabled)
  end

  it "includes the credit_limit" do
    expect(account_json).to include(credit_limit: account.credit_limit)
  end
end