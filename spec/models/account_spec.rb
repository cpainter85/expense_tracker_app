require "rails_helper"

describe Account do
  describe "relationships" do
    it { should have_many(:activities) }
  end
end