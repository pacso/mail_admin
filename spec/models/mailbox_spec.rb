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
  
  it "does not allow empty passwords" do
    mailbox = build(:mailbox, password: nil, password_confirmation: nil)
    # expect(mailbox).to_not be_valid
    expect(mailbox).to have(1).errors_on(:password)
  end
  
  it "must have a move_spam_threshold greater than zero" do
    mailbox = build(:mailbox, move_spam_threshold: 0)
    expect(mailbox).to have(1).errors_on(:move_spam_threshold)
  end
  
  it "must have a delete_spam_threshold greater than the move_spam_threshold" do
    mailbox = build(:mailbox, move_spam_threshold: 3, delete_spam_threshold: 2)
    expect(mailbox).to have(1).errors_on(:delete_spam_threshold)
  end
  
  it "should be invalid without a forwarding_address if forwarding_enabled" do
    mailbox = build(:mailbox, forwarding_enabled: true)
    expect(mailbox).to have(1).errors_on(:forwarding_address)
  end
  
  it "should not allow local delivery when forwarding enabled" do
    mailbox = build(:mailbox, forwarding_enabled: true, forwarding_address: 'test@example.com')
    expect(mailbox).to have(1).errors_on(:delivery_enabled)
  end

  # Instance Methods
  it "#email returns a full email address as a string" do
    domain = create(:domain, name: 'test-domain.com')
    mailbox = build(:mailbox, domain: domain, local_part: 'test-account')
    expect(mailbox.email).to eq "test-account@test-domain.com"
  end
  
  it "#password= updates exim_password_digest" do
    old_password = 'password'
    new_password = 'newpass!'
    mailbox = create(:mailbox, password: old_password, password_confirmation: old_password)
    old_exim_password_digest = mailbox.exim_password_digest
    mailbox.password = new_password
    expect(mailbox.exim_password_digest).to_not eq old_exim_password_digest
  end
  
  it "exim_password_digest is set with the correct hash" do
    password = 'testpass123'
    md5_hash = 'cd8ae748d23722682cc20ad62e7cb6e9'
    mailbox = create(:mailbox, password: password, password_confirmation: password)
    expect(mailbox.exim_password_digest).to eq md5_hash
  end
  
  it "#move_spam_threshold= updates move_spam_threshold_int" do
    mailbox = build(:mailbox)
    mailbox.move_spam_threshold = 4.8
    expect(mailbox.move_spam_threshold_int).to eq 48
  end
  
  it "#delete_spam_threshold= updates delete_spam_threshold_int" do
    mailbox = build(:mailbox)
    mailbox.delete_spam_threshold = 9.8
    expect(mailbox.delete_spam_threshold_int).to eq 98
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
