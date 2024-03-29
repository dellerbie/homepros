require 'spec_helper'

describe Listing do
  it { should validate_presence_of :company_name }
  it { should validate_presence_of :contact_email }
  it { should validate_presence_of :phone }
  it { should validate_presence_of(:city).with_message(/Please select a city closest to your business/) }
  it { should validate_presence_of(:specialties).with_message(/Please select at least one specialty/) }
  it { should validate_presence_of(:portfolio_photos).with_message(/Please upload at least one portfolio photo/) }
  
  it { should_not validate_presence_of :company_logo_photo }
  it { should_not validate_presence_of :website }
  
  it { should ensure_length_of(:company_name).is_at_most(255) }
  
  it { should allow_value("5555555555").for(:phone) }
  it { should allow_value("555-555-5555").for(:phone) }
  it { should allow_value("555 555 5555").for(:phone) }
  it { should allow_value("(555) 555-5555").for(:phone) }
  it { should_not allow_value("234").for(:phone) }
  it { should_not allow_value("12345678911").for(:phone) }
  
  it { should have_and_belong_to_many :specialties }
  it { should belong_to :city }
  it { should have_many :questions }
  it { should have_many :portfolio_photos }
  
  it { should ensure_length_of(:contact_email).is_at_most(255) }
  it { should allow_value("d@d.com").for(:contact_email) }
  it { should_not allow_value('d.com').for(:contact_email) }

  it { should allow_value("http://d.com").for(:website) }
  it { should allow_value("https://test.test.com").for(:website) }
  
  it { should ensure_length_of(:company_description).is_at_most(1000) }
  
  it { should accept_nested_attributes_for :portfolio_photos }
  
  [:specialty_ids, :city_id, :company_logo_photo, :company_name, :contact_email,
    :website, :phone, :company_logo_photo_cache, :company_description].each do |attr|
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
  
  it 'is premium' do 
    user = FactoryGirl.create(:user, premium: true)
    listing = FactoryGirl.create(:listing, user: user)
    expect(listing).to be_premium
  end
  
  it "should allow a max of #{Listing::MAX_FREE_PHOTOS} photos for a free listing" do
    listing = FactoryGirl.build(:listing)
    listing.portfolio_photos << FactoryGirl.build_list(:portfolio_photo, Listing::MAX_FREE_PHOTOS + 1)
    listing.save
    
    listing.reload
    expect(listing.portfolio_photos.length).to eql(Listing::MAX_FREE_PHOTOS)
  end
  
  it "should allow a max of #{Listing::MAX_PREMIUM_PHOTOS} photos for a premium listing" do
    listing = FactoryGirl.build(:listing, user: FactoryGirl.create(:premium_user))
    listing.portfolio_photos << FactoryGirl.build_list(:portfolio_photo, Listing::MAX_PREMIUM_PHOTOS + 1)
    listing.save
    
    listing.reload
    expect(listing.portfolio_photos.length).to eql(Listing::MAX_PREMIUM_PHOTOS)
  end
  
  it 'searches' do 
    joes_listing = FactoryGirl.create(:free_listing, company_name: "Joe's Home Improvement")
    sams_listing = FactoryGirl.create(:premium_listing, company_name: "Sam's Landscaping Pros")
    
    listings = Listing.search_by_company_name('joe')
    listings.should include(joes_listing)
    listings.should_not include(sams_listing)
  end
end