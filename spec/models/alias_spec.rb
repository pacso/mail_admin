require 'spec_helper'

describe Alias do
  it "has a valid factory" do
    create(:alias).should be_valid
  end
  
  # Validations
  it "is invalid without a local_part" do
    mailbox_alias = build(:alias, local_part: nil) #.should_not be_valid
    expect(mailbox_alias).to have(1).errors_on(:local_part)
  end
  
  it "is invalid without a mailbox" do
    mailbox_alias = build(:alias, mailbox_id: nil) #.should_not be_valid
    expect(mailbox_alias).to have(1).errors_on(:mailbox)
  end
  
  it "does not allow duplicate aliases on the same domain"
  it "does not allow an alias on a domain with a matching mailbox"
end
