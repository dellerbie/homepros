FactoryGirl.define do
  factory :user do
    email 'derrick@homepros.com'
    password 'abcd1234'
    
    factory :premium_user do
      premium true
      pending_downgrade false
      customer_id 'cus_1qFb5NbSiLcLDb'
      last_4_digits '1117'
      card_type 'Discover'
      exp_month '6'
      exp_year '2017'
      current_period_start Time.now
      current_period_end Time.at(30.days.from_now)
    end
  end
end
