class Mailbox < ActiveRecord::Base
  attr_accessible :delete_spam_enabled, :delete_spam_threshold, :delivery_enabled, :domain_id,
                  :enabled, :forwarding_address, :forwarding_enabled, :local_part, :move_spam_enabled,
                  :move_spam_threshold, :password_digest
  has_secure_password
  
  belongs_to :domain
  
  def self.find_by_email(address)
    local_part, domain = address.split('@')
    joins(:domain).select('CONCAT(mailboxes.local_part, \'@\', domains.name)').where('mailboxes.local_part = ? AND domains.name = ? AND mailboxes.enabled = 1', local_part, domain).first
  end
  
end
