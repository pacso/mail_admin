class Mailbox < ActiveRecord::Base
  attr_accessible :delete_spam_enabled, :delete_spam_threshold, :delivery_enabled, :domain_id,
                  :enabled, :forwarding_address, :forwarding_enabled, :local_part, :move_spam_enabled,
                  :move_spam_threshold, :exim_password_digest, :password, :password_confirmation,
                  :roles, :old_password
  has_secure_password
  
  ROLES = %w[site_admin domain_admin]
  
  belongs_to :domain
  
  scope :enabled, ->{ where(enabled: true) }
  scope :with_domain_id, ->(domain_id) { where(domain_id: domain_id) }
  
  validates :local_part,  :format => { :with => /^[^@^\ ]+$/, :if => Proc.new { |m| m.local_part.present? }},
                          :length => { :maximum => 64 },
                          :presence => true,
                          :uniqueness => { :scope => :domain_id, :case_sensitive => false }

  validates :domain,      :presence => true
  
  validates :delete_spam_threshold, :numericality => {greater_than: :move_spam_threshold, message: "must be greater than move spam threshold"}
  validates :move_spam_threshold,   :numericality => {  :greater_than => 0 }
  
  validates :forwarding_address, :format => { :with => /^[^@^\ ]+@[^@@\ ]+\.[^@@\ ]+$/,
                                              :message => "must be a valid email address when forwarding is enabled.",
                                              :if => Proc.new { |m| m.forwarding_enabled? } }
  validates :delivery_enabled,    inclusion: { in: [false],
                                               if: :forwarding_enabled?,
                                               message: "cannot be selected when mail forwarding is enabled."}
  
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end
  
  def roles
    ROLES.reject { |r| ((self.roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def has_role?(role)
    roles.include?(role.to_s)
  end
  
  def password=(unencrypted_password)
    super(unencrypted_password)
    unless unencrypted_password.blank?
      self.exim_password_digest = Digest::MD5.hexdigest(unencrypted_password)
    end
  end
  
  def move_spam_threshold=(float)
    write_attribute(:move_spam_threshold, float)
    self.move_spam_threshold_int = (float*10).to_i
  end
  
  def delete_spam_threshold=(float)
    write_attribute(:delete_spam_threshold, float)
    self.delete_spam_threshold_int = (float*10).to_i
  end
  
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
