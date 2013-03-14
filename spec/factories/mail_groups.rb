FactoryGirl.define do
  factory :mail_group do
    association :domain
    local_part { Faker::Internet.user_name }
    mailboxes { [create(:mailbox, domain: self.domain)] }
  end
end
