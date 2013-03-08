FactoryGirl.define do
  factory :listing do
    budget_id 1
    company_logo 'logo.png'
    company_name 'Dellerbie Inc.'
    contact_email 'derrick@dellerbie.com'
    portfolio_photo 'portfolio.png'
    portfolio_photo_description 'Sample of the work I did for Visa.com and Mastercard'
    city
    state 'CA'
    website 'http://dellerbie.com'
    phone_area_code 714
    phone_exchange 612
    phone_suffix 4587
    specialties { FactoryGirl.create_list(:specialty, 2) }
  end
end
