FactoryGirl.define do
  factory :mailbox do
    association :domain
    local_part { Faker::Internet.user_name }
    password "password"
    password_confirmation "password"
  end
  
  factory :invalid_mailbox, parent: :mailbox do
    local_part "invalid@localpart"
  end
  
  factory :disabled_mailbox, parent: :mailbox do
    enabled false
  end
  
  factory :site_admin_mailbox, parent: :mailbox do
    roles %w[site_admin]
  end
  
  factory :domain_admin_mailbox, parent: :mailbox do
    roles %w[domain_admin]
  end
end