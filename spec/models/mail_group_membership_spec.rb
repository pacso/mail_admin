require 'spec_helper'

describe MailGroupMembership do
  it "is invalid without a mailbox" do
    expect(MailGroupMembership.new).to have(1).errors_on(:mailbox)
  end
  
  it "is invalid without a mail_group" do
    expect(MailGroupMembership.new).to have(1).errors_on(:mail_group)
  end
end
