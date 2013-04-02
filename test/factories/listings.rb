FactoryGirl.define do
  factory :listing do
    budget_id 1
    company_logo_photo { File.open(File.join(Rails.root, 'test', 'fixtures', 'files', 'guitar.jpg')) }
    company_name 'Dellerbie Inc.'
    contact_email 'derrick@dellerbie.com'
    portfolio_photo { File.open(File.join(Rails.root, 'test', 'fixtures', 'files', 'guitar.jpg')) }
    portfolio_photo_description 'Sample of the work I did for Visa.com and Mastercard'
    city { FactoryGirl.create(:city) }
    state 'CA'
    website 'http://dellerbie.com'
    phone_area_code 714
    phone_exchange 612
    phone_suffix 4587
    specialties { FactoryGirl.create_list(:specialty, 2) }
  end
end
