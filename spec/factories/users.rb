FactoryGirl.define do
  factory :user do
    email 'derrick@homepros.com'
    password 'abcd1234'
    
    factory :premium_user do
      premium true
    end
  end
end
