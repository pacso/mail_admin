class MailGroupMembership < ActiveRecord::Base
  attr_accessible :mail_group_id, :mailbox_id
  
  belongs_to :mail_group
  belongs_to :mailbox
end
