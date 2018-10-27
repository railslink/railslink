FactoryBot.define do
  factory :slack_channel do
    sequence(:uid) { |n| "uid#{n}" }
    sequence(:name) { |n| "Channel #{n}" }
  end
end
