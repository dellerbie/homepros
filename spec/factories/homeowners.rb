FactoryGirl.define do
  factory :homeowner do
    email 'no-reply@ochomepros.com'
    city { FactoryGirl.create(:city) }
    received_flier true
  end
end