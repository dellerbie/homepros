FactoryGirl.define do
  factory :question do
    sender_email 'slowblues@gmail.com'
    text 'What is your typical budget range?  Are you available for a consultation on Friday @ noon?'
    listing
  end
end