class Mailbox < ActiveRecord::Base
  attr_accessible :delete_spam_enabled, :delete_spam_threshold, :delivery_enabled, :domain_id,
                  :enabled, :forwarding_address, :forwarding_enabled, :local_part, :move_spam_enabled,
                  :move_spam_threshold, :exim_password_digest, :password, :password_confirmation
  has_secure_password
  
  belongs_to :domain
  
  scope :enabled, ->{ where(enabled: true) }
  scope :with_domain_id, ->(domain_id) { where(domain_id: domain_id) }
  
  
  def email_address
    [local_part, domain.name].join '@'
  end
  
  def self.find_by_email(address)
    local_part, domain_name = address.split('@')
    if local_part && domain_name && domain = Domain.find_by_name(domain_name)
      enabled.with_domain_id(domain.id).find_by_local_part(local_part)
    else
      false
    end
  end
  
end
