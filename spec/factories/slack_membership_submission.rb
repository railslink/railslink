FactoryBot.define do
  factory :slack_membership_submission do
    first_name "John"
    last_name "Doe"
    sequence(:email) { |n| "john#{n}@doe.com" }
  end
end
