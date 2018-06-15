FactoryBot.define do
  factory :slack_membership_submission do
    first_name "John"
    last_name "Doe"
    introduction "Some intro here."
    sequence(:email) { |n| "john#{n}@doe.com" }
    
    factory :approved_slack_membership_submission do
      status "approved"
    end
  end
end
