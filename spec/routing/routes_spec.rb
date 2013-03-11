require 'spec_helper'

describe "Routes" do
  describe "Homepage" do
    it "routes / to pages#index" do
      { get: '/' }.should route_to(
        controller: "pages",
        action: "index"
      )
    end
  end
end