require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  should validate_presence_of :city
  should validate_presence_of :portfolio_photo
  should validate_presence_of :portfolio_photo_description
  should validate_presence_of :company_name
  should validate_presence_of :budget
  should validate_presence_of :city
  should validate_presence_of :contact_email
  should validate_presence_of :phone_area_code
  should validate_presence_of :phone_exchange
  should validate_presence_of :phone_suffix
  should_not validate_presence_of :company_logo
  should_not validate_presence_of :website
  
  should ensure_length_of(:portfolio_photo_description).is_at_most(255)
  should ensure_length_of(:company_name).is_at_most(255)
  
  should have_and_belong_to_many :specialties
  
  should ensure_length_of(:contact_email).is_at_most(255)
  should allow_value("d@d.com").for(:contact_email)
  should_not allow_value('d.com').for(:contact_email)

  should ensure_length_of(:website).is_at_most(255)
  should allow_value("http://d.com").for(:website)
  should allow_value("https://test.test.com").for(:website)
  should_not allow_value('d.com').for(:website)
  
  [:budget, :city, :company_logo, :company_name, :contact_email,
    :portfolio_photo, :portfolio_photo_description, :website, 
    :phone_area_code, :phone_exchange, :phone_suffix].each do |attr|
      should allow_mass_assignment_of(attr)
  end
  
  should_not allow_mass_assignment_of(:state)
  
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
    listing = FactoryGirl.create(:listing)
    listing.specialties << FactoryGirl.create(:specialty)
    listing.specialties << FactoryGirl.create(:specialty)
    assert listing.valid?
    
    listing.specialties << FactoryGirl.create(:specialty)
    listing.valid?
    assert listing.errors.messages[:specialties].include?('You cannot have more than 2 specialties')
  end
  
  test 'should set the state to CA after creation' do
    listing = FactoryGirl.build(:listing, state: '')
    listing.save
    assert_equal 'CA', listing.state
  end
  
  test 'mass assignment' do
    

  end

end
