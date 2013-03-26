module Emailable
  extend ActiveSupport::Concern
    
  included do
    validates :local_part,  format: { with: /^[^@^\ ]+$/, if: Proc.new { |m| m.local_part.present? }},
                            length: { maximum: 64 },
                            presence: true,
                            uniqueness_on_domain: { if: :domain }
    validates :domain,  presence: true
    
    default_scope includes(:domain)
  end
  
  def email
    [local_part, domain.name].join '@'
  end
end