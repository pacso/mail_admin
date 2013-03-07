FactoryGirl.define do
  factory :mailbox do
    association :domain
    local_part { Faker::Internet.user_name }
    password "password"
    password_confirmation "password"
  end
end