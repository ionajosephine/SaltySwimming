FactoryBot.define do
  factory :station do
    sequence(:name) { |n| "Station #{n}" }
    sequence(:admiralty_id)
    latitude { 9.99 }
    longitude { 8.88 }
  end
end
