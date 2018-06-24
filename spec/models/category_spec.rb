require "rails_helper"

describe Category do
  describe "relationships" do
    it { should have_many(:activities) }
  end
end