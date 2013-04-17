require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  should validate_presence_of(:portfolio_photo).with_message(/Please upload a sample photo of your work/)
  should validate_presence_of :portfolio_photo_description
  should validate_presence_of :company_name
  should validate_presence_of :contact_email
  should validate_presence_of :phone
  should validate_presence_of(:city).with_message(/Please select a city closest to your business/)
  should validate_presence_of(:specialties).with_message(/Please select at least one specialty/)
  
  should_not validate_presence_of :company_logo_photo
  should_not validate_presence_of :website
  
  should ensure_length_of(:portfolio_photo_description).is_at_most(255)
  should ensure_length_of(:company_name).is_at_most(255)
  
  should allow_value("5555555555").for(:phone)
  should allow_value("555-555-5555").for(:phone)
  should allow_value("555 555 5555").for(:phone)
  should allow_value("(555) 555-5555").for(:phone)
  should_not allow_value("234").for(:phone)
  should_not allow_value("12345678911").for(:phone)
  
  should have_and_belong_to_many :specialties
  should belong_to :city
  
  should ensure_length_of(:contact_email).is_at_most(255)
  should allow_value("d@d.com").for(:contact_email)
  should_not allow_value('d.com').for(:contact_email)

  should allow_value("http://d.com").for(:website)
  should allow_value("https://test.test.com").for(:website)
  
  should ensure_length_of(:company_description).is_at_most(1000)
  
  [:specialty_ids, :city_id, :company_logo_photo, :company_name, :contact_email,
    :portfolio_photo, :portfolio_photo_description, :website, 
    :phone, :company_logo_photo_cache, :portfolio_photo_cache,
    :company_description].each do |attr|
      should allow_mass_assignment_of(attr)
  end
  
  should_not allow_mass_assignment_of(:state)
  
  test 'should allow a max of 2 specialties' do
    listing = FactoryGirl.build(:listing)
    listing.specialties << FactoryGirl.create(:specialty)
    assert !listing.valid?
    assert listing.errors.messages[:specialties].include?('You cannot have more than 2 specialties')
  end
  
  test 'should set the state to CA after creation' do
    listing = FactoryGirl.build(:listing, state: '')
    listing.save
    assert_equal 'CA', listing.state
  end
  
  test 'should append http to website' do 
    listing = FactoryGirl.build(:listing, website: 'mysite.com')
    assert listing.valid?
    assert_equal 'http://mysite.com', listing.website
  end
  
  test 'should not append http or https to website if it already has it' do
    listing = FactoryGirl.build(:listing, website: 'http://mysite.com')
    assert listing.valid?
    assert_equal 'http://mysite.com', listing.website
    
    listing.website = 'https://www.mysite.com'
    assert listing.valid?
    assert_equal 'https://www.mysite.com', listing.website
  end

end
