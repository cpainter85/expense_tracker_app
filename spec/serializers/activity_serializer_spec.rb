require "rails_helper"

describe ActivitySerializer do
  let(:activity) { create(:activity) }
  subject(:activity_json) { ActivitySerializer.new(activity).as_json }

  it "includes the id" do
    expect(activity_json).to include(id: activity.id)
  end

  it "includes the transaction_date" do
    expect(activity_json).to include(transaction_date: activity.transaction_date)
  end

  it "includes the merchant" do
    expect(activity_json).to include(merchant: activity.merchant)
  end

  it "includes the description" do
    expect(activity_json).to include(description: activity.description)
  end

  it "includes the cleared" do
    expect(activity_json).to include(cleared: activity.cleared)
  end

  it "includes the amount" do
    expect(activity_json).to include(amount: activity.amount)
  end

  it "includes the account using the AccountSerializer" do
    expect(activity_json).to include(account: AccountSerializer.new(activity.account).as_json)
  end

  it "includes the category using the CategorySerializer" do
    expect(activity_json).to include(category: CategorySerializer.new(activity.category).as_json)
  end
end