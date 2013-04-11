require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  should validate_presence_of(:portfolio_photo).with_message(/Please upload a sample photo of your work/)
  should validate_presence_of :portfolio_photo_description
  should validate_presence_of :company_name
  should validate_presence_of(:budget_id).with_message(/Please choose a typical budget/)
  should validate_presence_of :contact_email
  should validate_presence_of :phone_area_code
  should validate_presence_of :phone_exchange
  should validate_presence_of :phone_suffix
  should validate_presence_of(:city).with_message(/Please select a city closest to your business/)
  should validate_presence_of(:specialties).with_message(/Please select at least one specialty/)
  
  should_not validate_presence_of :company_logo_photo
  should_not validate_presence_of :website
  
  should ensure_length_of(:portfolio_photo_description).is_at_most(255)
  should ensure_length_of(:company_name).is_at_most(255)
  
  should have_and_belong_to_many :specialties
  should belong_to :city
  
  should ensure_length_of(:contact_email).is_at_most(255)
  should allow_value("d@d.com").for(:contact_email)
  should_not allow_value('d.com').for(:contact_email)

  should allow_value("http://d.com").for(:website)
  should allow_value("https://test.test.com").for(:website)
  
  should ensure_length_of(:company_description).is_at_most(1000)
  
  [:budget_id, :specialty_ids, :city_id, :company_logo_photo, :company_name, :contact_email,
    :portfolio_photo, :portfolio_photo_description, :website, 
    :phone_area_code, :phone_exchange, :phone_suffix, :company_logo_photo_cache, :portfolio_photo_cache,
    :company_description].each do |attr|
      should allow_mass_assignment_of(attr)
  end
  
  should_not allow_mass_assignment_of(:state)
  
  should ensure_inclusion_of(:budget_id).in_array(Listing::BUDGETS.keys)
  
  test 'should not accept alpha characters for the phone number' do
    listing = Listing.new
    
    [:phone_area_code, :phone_exchange, :phone_suffix].each do |key|      
      listing[key] = 'xxx'
      assert !listing.valid?
      assert listing.errors.messages[key].include?("is not a number")
    end
  end
  
  test 'should only accept 3 integers for the area code and exchange' do
    listing = Listing.new
    [:phone_area_code, :phone_exchange].each do |key|      
      listing[key] = 1234
      assert !listing.valid?
      assert listing.errors.messages[key].include?("must be 3 numbers")
      
      listing[key] = 123
      listing.valid?
      assert listing.errors.messages[key].nil?
    end
  end
  
  test 'should only accept 4 integers for the phone suffix' do
    listing = Listing.new
    listing.phone_suffix = 1234
    listing.save
    assert listing.errors.messages[:phone_suffix].nil?
    
    listing.phone_suffix = 123
    listing.valid?
    assert listing.errors.messages[:phone_suffix].include?("must be 4 numbers")
  end
  
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
