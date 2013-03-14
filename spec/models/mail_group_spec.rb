require 'spec_helper'

describe MailGroup do
  it "has a valid factory" do
    create(:mail_group).should be_valid
  end
  
  # Validations
  it "is invalid without a local_part" do
    mail_group = build(:mail_group, local_part: nil) #.should_not be_valid
    expect(mail_group).to have(1).errors_on(:local_part)
  end
  
  it "must not allow a local_part longer than 64 characters" do
    mail_group = build(:mail_group, local_part: (0...65).map{ ('a'..'z').to_a[rand(26)] }.join)
    expect(mail_group).to have(1).errors_on(:local_part)
  end

  it "must be associated with a domain" do
    mail_group = build(:mail_group, domain_id: nil)
    expect(mail_group).to have(1).errors_on(:domain)
  end

  it "does not allow duplicate mail_groups per domain" do
    domain = create(:domain)
    create(:mail_group, domain: domain, local_part: 'test')
    mail_group = build(:mail_group, domain: domain, local_part: 'test')
    domain.reload # required to pick up the added mailbox and alias
    expect(mail_group).to have(1).errors_on(:local_part)
  end
  
  it "does not allow a mail group on a domain with a matching alias" do
    domain = create(:domain)
    mailbox = create(:mailbox, domain: domain)
    mailbox_alias = create(:mailbox_alias, mailbox: mailbox, local_part: 'local_part')
    mail_group = build(:mail_group, domain: domain, local_part: 'local_part')
    domain.reload # required to pick up the added mailbox and alias
    expect(mail_group).to have(1).errors_on(:local_part)
  end
  
  it "does not allow a mailbox on a domain with a matching mailbox" do
    domain = create(:domain)
    create(:mailbox, domain: domain, local_part: 'local_part')
    mail_group = build(:mail_group, domain: domain, local_part: 'local_part')
    domain.reload # required to pick up the added mailbox and alias
    expect(mail_group).to have(1).errors_on(:local_part)
  end
  
  it "must not be enabled without any mailboxes" do
    domain = create(:domain)
    mail_group = domain.mail_groups.build(local_part: 'group_address', enabled: true)
    expect(mail_group).to have(1).errors_on(:enabled)
  end
  
  # Instance Methods
  it "#email returns a full email address as a string" do
    domain = create(:domain, name: 'test-domain.com')
    mail_group = build(:mail_group, domain: domain, local_part: 'test-account')
    expect(mail_group.email).to eq "test-account@test-domain.com"
  end
end
