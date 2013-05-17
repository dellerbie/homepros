FactoryGirl.define do
  factory :listing do
    company_logo_photo { File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'guitar.jpg')) }
    company_name 'Dellerbie Inc.'
    contact_email 'derrick@dellerbie.com'
    city { FactoryGirl.create(:city) }
    state 'CA'
    website 'http://dellerbie.com'
    phone "7146124582"
    
    after(:build) do |listing|
      listing.specialties << FactoryGirl.build(:specialty) << FactoryGirl.build(:specialty)
    end
    
    after(:build) do |listing|
      listing.portfolio_photos << FactoryGirl.build(:portfolio_photo)
    end
  end
end
