require "rails_helper"

describe CategorySerializer do
  let(:category) { create(:category) }
  subject(:category_json) { CategorySerializer.new(category).as_json }
  
  it "includes the id" do
    expect(category_json).to include(id: category.id)
  end

  it "includes the name" do
    expect(category_json).to include(name: category.name)
  end
end