class MailboxAlias < ActiveRecord::Base
  attr_accessible :local_part, :mailbox_id
  
  include Emailable
  
  belongs_to :mailbox
  has_one :domain, through: :mailbox
  
  validates :mailbox,     :presence => true
end
