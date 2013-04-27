FactoryGirl.define do
  factory :listing do
    company_logo_photo { File.open(File.join(Rails.root, 'test', 'fixtures', 'files', 'guitar.jpg')) }
    company_name 'Dellerbie Inc.'
    contact_email 'derrick@dellerbie.com'
    portfolio_photo { File.open(File.join(Rails.root, 'test', 'fixtures', 'files', 'guitar.jpg')) }
    portfolio_photo_description 'Sample of the work I did for Visa.com and Mastercard'
    city { FactoryGirl.create(:city) }
    state 'CA'
    website 'http://dellerbie.com'
    phone "7146124582"
    
    after(:build) do |listing|
      listing.specialties.delete_all
      listing.specialties << FactoryGirl.build(:specialty) << FactoryGirl.build(:specialty)
    end
  end
end
