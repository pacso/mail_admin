class MailGroup < ActiveRecord::Base
  attr_accessible :domain_id, :enabled, :local_part, :mailbox_ids
  
  include Emailable
  
  belongs_to :domain
  has_many :mail_group_memberships
  has_many :mailboxes, through: :mail_group_memberships
  
  scope :enabled, ->{ where(enabled: true) }  
  
  validates :enabled, inclusion: { in: [false], if: Proc.new { |m| m.mail_group_memberships.empty? }, message: "can not enable group witout any members"}
end
