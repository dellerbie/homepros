require 'spec_helper'

describe User do
  it { should validate_presence_of :email }
  it { should allow_value("d@d.com").for(:email) }
  it { should_not allow_value('d.com').for(:email) }
  
  it { should validate_presence_of :password }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should ensure_length_of(:password).is_at_most(128) }
  
  it { should_not allow_mass_assignment_of(:premium) }
  it { should_not allow_mass_assignment_of(:pending_downgrade) }
  it { should_not allow_mass_assignment_of(:customer_id) }
  it { should_not allow_mass_assignment_of(:last_4_digits) }
  it { should_not allow_mass_assignment_of(:card_type) }
  it { should_not allow_mass_assignment_of(:exp_month) }
  it { should_not allow_mass_assignment_of(:exp_year) }
  
  it { should allow_mass_assignment_of(:stripe_token) }
  
  it { should accept_nested_attributes_for :listing }
  
  it 'should accept nested attributes for listing portfolio_photos' do
    listing_attributes = FactoryGirl.attributes_for(:listing).except(:state, :specialties, :city)
    listing_attributes[:specialty_ids] = [FactoryGirl.create(:specialty).id, FactoryGirl.create(:specialty).id]
    listing_attributes[:city_id] = FactoryGirl.create(:city).id
    listing_attributes[:company_logo_photo] = Rack::Test::UploadedFile.new(Rails.root.to_s + '/spec/fixtures/files/guitar.jpg', 'image/jpeg')
    # listing_attributes[:portfolio_photo] = Rack::Test::UploadedFile.new(Rails.root.to_s + '/spec/fixtures/files/guitar.jpg', 'image/jpeg')
    listing_attributes[:portfolio_photos_attributes] = [FactoryGirl.attributes_for(:portfolio_photo)]
    
    user = FactoryGirl.attributes_for(:user)
    user[:listing_attributes] = listing_attributes
    
    _user = User.new(user)
    expect { 
      _user.save
    }.to change{ User.count }
  end
  
  describe 'premium' do
    before(:each) do
      successful_stripe_response = StripeHelper::Response.new("customer_success")
      successful_stripe_response.stub(:update_subscription).and_return(nil)
      successful_stripe_response.stub(:cancel_subscription).and_return(nil)
      Stripe::Customer.stub(:create).and_return(successful_stripe_response)
      Stripe::Customer.stub(:retrieve).and_return(successful_stripe_response)
    end
    
    let(:user) do 
      FactoryGirl.create(:user)
    end
    
    let(:visa) do
      {
        number: '4242424242424242',
        exp_month: '4',
        exp_year: 1.year.from_now.year.to_s,
        cvc: '123'
      }
    end
    
    it 'should not be premium by default' do
      expect(user).to_not be_premium
    end
    
    it 'should not have a customer_id' do 
      expect(user.customer_id).to be_nil
    end
    
    it 'should not have last_4_digits' do
      expect(user.last_4_digits).to be_nil
    end
    
    it 'should not have card_type' do
      expect(user.card_type).to be_nil
    end
    
    it 'should not have exp_month' do
      expect(user.exp_month).to be_nil
    end
    
    it 'should not have exp_year' do
      expect(user.exp_year).to be_nil
    end
    
    it 'should not have current_period_start' do
      expect(user.current_period_start).to be_nil
    end
    
    it 'should not have current_period_end' do
      expect(user.current_period_end).to be_nil
    end
    
    context 'upgrade' do
      it 'success' do
        user.stripe_token = "abcd1234"
        expect(user.upgrade).to be_true
        user.reload
        
        expect(user.last_4_digits).to eql(visa[:number].slice(-4..-1))
        expect(user.card_type).to eql('Visa')
        expect(user.exp_month).to eql(visa[:exp_month])
        expect(user.exp_year).to eql(visa[:exp_year])
        expect(user.customer_id).to_not be_nil
        expect(user.current_period_start).to_not be_nil
        expect(user.current_period_end).to_not be_nil
        expect(user.stripe_token).to be_nil
        expect(user).to be_premium
      end
      
      it 'should not upgrade to premium if stripe_token is blank' do 
        Stripe::Customer.stub(:create).and_raise(Stripe::StripeError)
        expect(user.upgrade).to be_false
        expect(user.errors).to_not be_empty
      end

      it 'should upgrade the user if already a stripe customer' do
        user.stripe_token = "abcd1234"
        user.upgrade
        user.reload
        expect(user).to be_premium

        user.downgrade
        user.stripe_token = "abcd1234"
        expect(user.upgrade).to be_true
        user.reload
        expect(user).to be_premium
      end
      
      it 'throws Stripe::Error' do 
        Stripe::Customer.stub(:create).and_raise(Stripe::StripeError)
        
        user.stripe_token = 'abcd1234'
        expect(user.upgrade).to be_false
        expect(user.errors).to_not be_empty
        expect(user).to_not be_premium
      end
    end
    
    context 'downgrade' do
      it 'success' do 
        expect(user.pending_downgrade).to be_false
        
        user.stripe_token = "abcd1234"
        user.upgrade
        expect(user.downgrade).to be_true
        user.reload
        
        expect(user.pending_downgrade).to be_true

        expect(user).to be_premium # still premium until the end of the charge cycle
        expect(user.last_4_digits).to eql(visa[:number].slice(-4..-1))
        expect(user.card_type).to eql('Visa')
        expect(user.exp_month).to eql(visa[:exp_month])
        expect(user.exp_year).to eql(visa[:exp_year])
        expect(user.customer_id).to_not be_nil
        expect(user.current_period_start).to_not be_nil
        expect(user.current_period_end).to_not be_nil
        expect(user.stripe_token).to be_nil
      end
    end
    
    context '#before_destroy' do
      it 'cancels subscription' do 
        expect(user.upgrade).to be_true
        user.reload
        expect(user.premium).to be_true
        
        expect {
          user.destroy
        }.to change{ user.pending_downgrade }.from(false).to(true)
      end
    end
  end
end