require 'spec_helper'

describe Mailbox do
  it "has a valid factory" do
    create(:mailbox).should be_valid
  end
  
  it "is invalid without a local_part" do
    build(:mailbox, local_part: nil).should_not be_valid
  end
  
  it "must not allow a local_part longer than 64 characters" do
    build(:mailbox, local_part: (0...65).map{ ('a'..'z').to_a[rand(26)] }.join).should_not be_valid
  end
  
  it "must be associated with a domain" do
    build(:mailbox, domain_id: nil).should_not be_valid
  end
  
  it "returns a full email address as a string" do
    domain = create(:domain)
    mailbox = build(:mailbox, domain: domain)
    mailbox.email_address.should eq mailbox.local_part + '@' + domain.name
  end
end
