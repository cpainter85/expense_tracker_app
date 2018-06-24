require "rails_helper"

describe Activity do
  describe "relationships" do
    it { should belong_to(:account) }
    it { should belong_to(:category) }
  end
end