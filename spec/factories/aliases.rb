# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alias do
    local_part "MyString"
    association :mailbox
  end
end
