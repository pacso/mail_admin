require 'spec_helper'

describe "Routes" do
  describe "Homepage" do
    it "routes / to sessions#new when not signed in" do
      { get: '/' }.should route_to(
        controller: "sessions",
        action: "new"
      )
    end
  end
end