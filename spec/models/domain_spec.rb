require 'spec_helper'

describe Domain do
  it "has a valid factory" do
    create(:domain).should be_valid
  end
  
  it "is invalid without a domain name" do
    build(:domain, name: nil).should_not be_valid
  end
  
  it "must have a unique domain name" do
    domain = create(:domain)
    build(:domain, name: domain.name).should_not be_valid
  end
end
