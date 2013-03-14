class MailGroup < ActiveRecord::Base
  attr_accessible :domain_id, :enabled, :local_part, :mailbox_ids
  
  belongs_to :domain
  has_many :mail_group_memberships
  has_many :mailboxes, through: :mail_group_memberships
  
  validates :local_part,  format: { with: /^[^@^\ ]+$/, if: Proc.new { |m| m.local_part.present? }},
                          length: { maximum: 64 },
                          presence: true,
                          uniqueness_on_domain: { if: :domain }
  validates :domain, presence: true
  validates :enabled, inclusion: { in: [false], if: Proc.new { |m| m.mail_group_memberships.empty? }, message: "can not enable group witout any members"}
  
  def email
    [local_part, domain.name].join '@'
  end
end
