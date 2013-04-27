require 'spec_helper'

describe Listing do
  it { should validate_presence_of(:portfolio_photo).with_message(/Please upload a sample photo of your work/) }
  it { should validate_presence_of :portfolio_photo_description }
  it { should validate_presence_of :company_name }
  it { should validate_presence_of :contact_email }
  it { should validate_presence_of :phone }
  it { should validate_presence_of(:city).with_message(/Please select a city closest to your business/) }
  it { should validate_presence_of(:specialties).with_message(/Please select at least one specialty/) }
  
  it { should_not validate_presence_of :company_logo_photo }
  it { should_not validate_presence_of :website }
  
  it { should ensure_length_of(:portfolio_photo_description).is_at_most(255) }
  it { should ensure_length_of(:company_name).is_at_most(255) }
  
  it { should allow_value("5555555555").for(:phone) }
  it { should allow_value("555-555-5555").for(:phone) }
  it { should allow_value("555 555 5555").for(:phone) }
  it { should allow_value("(555) 555-5555").for(:phone) }
  it { should_not allow_value("234").for(:phone) }
  it { should_not allow_value("12345678911").for(:phone) }
  
  it { should have_and_belong_to_many :specialties }
  it { should belong_to :city }
  
  it { should ensure_length_of(:contact_email).is_at_most(255) }
  it { should allow_value("d@d.com").for(:contact_email) }
  it { should_not allow_value('d.com').for(:contact_email) }

  it { should allow_value("http://d.com").for(:website) }
  it { should allow_value("https://test.test.com").for(:website) }
  
  it { should ensure_length_of(:company_description).is_at_most(1000) }
  
  [:specialty_ids, :city_id, :company_logo_photo, :company_name, :contact_email,
    :portfolio_photo, :portfolio_photo_description, :website, 
    :phone, :company_logo_photo_cache, :portfolio_photo_cache,
    :company_description].each do |attr|
      it {should allow_mass_assignment_of(attr) }
  end
  
  it { should_not allow_mass_assignment_of(:state) }
  it { should_not allow_mass_assignment_of(:claimable) }
  
  it 'should allow a max of 2 specialties' do
    listing = FactoryGirl.build(:listing)
    listing.specialties << FactoryGirl.create(:specialty)
    
    listing.should_not be_valid
    listing.errors.messages[:specialties].should include('You cannot have more than 2 specialties')
  end
  
  it 'should set the state to CA after creation' do
    listing = FactoryGirl.build(:listing, state: '')
    listing.save
    listing.state.should eql('CA')
  end
  
  it 'should append http to website' do 
    listing = FactoryGirl.build(:listing, website: 'mysite.com')
    listing.should be_valid
    listing.website.should eql('http://mysite.com')
  end
  
  it 'should not append http or https to website if it already has it' do
    listing = FactoryGirl.build(:listing, website: 'http://mysite.com')
    listing.should be_valid
    listing.website.should eql('http://mysite.com')
    
    listing.website = 'https://www.mysite.com'
    listing.should be_valid
    listing.website.should eql('https://www.mysite.com')
  end
  
  it 'should not be claimable by default' do 
    listing = FactoryGirl.build(:listing)
    listing.should_not be_claimable
  end
  
  it 'can make a listing claimable' do 
    listing = FactoryGirl.create(:listing, claimable: true)
    listing.should be_claimable
  end
end