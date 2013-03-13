require 'spec_helper'

describe MailboxAlias do
  it "has a valid factory" do
    create(:mailbox_alias).should be_valid
  end
  
  # Validations
  it "is invalid without a local_part" do
    mailbox_alias = build(:mailbox_alias, local_part: nil) #.should_not be_valid
    expect(mailbox_alias).to have(1).errors_on(:local_part)
  end
  
  it "is invalid without a mailbox" do
    mailbox_alias = build(:mailbox_alias, mailbox_id: nil) #.should_not be_valid
    expect(mailbox_alias).to have(1).errors_on(:mailbox)
  end
  
  it "does not allow duplicate aliases on the same domain" do
    domain = create(:domain)
    mailbox1 = create(:mailbox, domain: domain)
    mailbox2 = create(:mailbox, domain: domain)
    create(:mailbox_alias, mailbox: mailbox1, local_part: 'alias_test')
    mailbox_alias = build(:mailbox_alias, mailbox: mailbox2, local_part: 'alias_test')
    expect(mailbox_alias).to have(1).errors_on(:local_part)
  end
  
  it "does not allow an alias on a domain with a matching mailbox" do
    domain = create(:domain)
    mailbox = create(:mailbox, domain: domain, local_part: 'localpart')
    mailbox_alias = build(:mailbox_alias, mailbox: mailbox, local_part: 'localpart')    
    expect(mailbox_alias).to have(1).errors_on(:local_part)
  end
end
