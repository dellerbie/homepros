# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :specialty do
    name { Faker::Lorem.characters(12) }
  end
end
