require 'spec_helper'

describe Mailbox do
  it "has a valid factory" do
    create(:mailbox).should be_valid
  end
  
  # Validations
  it "is invalid without a local_part" do
    build(:mailbox, local_part: nil).should_not be_valid
  end
  
  it "must not allow a local_part longer than 64 characters" do
    build(:mailbox, local_part: (0...65).map{ ('a'..'z').to_a[rand(26)] }.join).should_not be_valid
  end
  
  it "must be associated with a domain" do
    build(:mailbox, domain_id: nil).should_not be_valid
  end
  
  it "does not allow duplicate mailboxes per domain" do
    domain = create(:domain)
    create(:mailbox, domain: domain, local_part: 'test')
    build(:mailbox, domain: domain, local_part: 'test').should_not be_valid
  end

  # Instance Methods
  it "returns a full email address as a string" do
    domain = create(:domain, name: 'test-domain.com')
    mailbox = build(:mailbox, domain: domain, local_part: 'test-account')
    mailbox.email_address.should eq "test-account@test-domain.com"
  end
  
  # Class Methods
  it "returns a mailbox when searching for a full address" do
    domain = create(:domain, name: 'example.com')
    mailbox = create(:mailbox, domain: domain, local_part: 'user')
    Mailbox.find_by_email("user@example.com").should eq mailbox
  end
  
  it "returns false when no mailbox is found" do
    Mailbox.find_by_email("user@example.com").should be false
  end
  
end
