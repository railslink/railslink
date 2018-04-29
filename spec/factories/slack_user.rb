FactoryBot.define do
  factory :slack_user do
    sequence(:uid) { |n| "uid#{n}" }
    first_name "John"
    last_name "Doe"
    sequence(:email) { |n| "john#{n}@doe.com" }
  end
end
