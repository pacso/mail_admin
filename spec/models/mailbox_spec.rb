require 'spec_helper'

describe Mailbox do
  it "has a valid factory" do
    create(:mailbox).should be_valid
  end
  
  # Validations
  it "is invalid without a local_part" do
    mailbox = build(:mailbox, local_part: nil) #.should_not be_valid
    expect(mailbox).to have(1).errors_on(:local_part)
  end
  
  it "must not allow a local_part longer than 64 characters" do
    mailbox = build(:mailbox, local_part: (0...65).map{ ('a'..'z').to_a[rand(26)] }.join)
    expect(mailbox).to have(1).errors_on(:local_part)
  end
  
  it "must be associated with a domain" do
    mailbox = build(:mailbox, domain_id: nil)
    expect(mailbox).to have(1).errors_on(:domain)
  end
  
  it "does not allow duplicate mailboxes per domain" do
    domain = create(:domain)
    create(:mailbox, domain: domain, local_part: 'test')
    mailbox = build(:mailbox, domain: domain, local_part: 'test')
    expect(mailbox).to have(1).errors_on(:local_part)
  end
  
  it "must have a move_spam_threshold greater than zero" do
    mailbox = build(:mailbox, move_spam_threshold: 0)
    expect(mailbox).to have(1).errors_on(:move_spam_threshold)
  end
  
  it "must have a delete_spam_threshold greater than the move_spam_threshold" do
    mailbox = build(:mailbox, move_spam_threshold: 3, delete_spam_threshold: 2)
    expect(mailbox).to have(1).errors_on(:delete_spam_threshold)
  end

  # Instance Methods
  it "returns a full email address as a string" do
    domain = create(:domain, name: 'test-domain.com')
    mailbox = build(:mailbox, domain: domain, local_part: 'test-account')
    expect(mailbox.email_address).to eq "test-account@test-domain.com"
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
