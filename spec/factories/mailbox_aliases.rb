# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mailbox_alias do
    local_part "MyString"
    association :mailbox
  end
end
