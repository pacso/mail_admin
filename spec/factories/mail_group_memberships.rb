FactoryGirl.define do
  factory :mail_group_membership do
    association :mailbox
    association :mail_group
  end
end
