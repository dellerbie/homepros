FactoryGirl.define do
  factory :listing do
    company_logo_photo { File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'guitar.jpg')) }
    company_name 'Dellerbie Inc.'
    contact_email 'derrick@dellerbie.com'
    city { FactoryGirl.create(:city) }
    state 'CA'
    website 'http://dellerbie.com'
    phone "7146124582"
    
    factory :free_listing do
      association :user, factory: :user
    end
    
    factory :premium_listing do
      association :user, factory: :premium_user
    end
    
    factory :claimable_listing do 
      association :user, nil
      claimable true
    end
    
    after(:build) do |listing|
      listing.specialties << FactoryGirl.build(:specialty) << FactoryGirl.build(:specialty)
    end
    
    after(:build) do |listing|
      listing.portfolio_photos << FactoryGirl.build(:portfolio_photo)
    end
  end
end
