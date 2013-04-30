require 'spec_helper'

describe User do
  it { should validate_presence_of :email }
  it { should allow_value("d@d.com").for(:email) }
  it { should_not allow_value('d.com').for(:email) }
  
  it { should validate_presence_of :password }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should ensure_length_of(:password).is_at_most(128) }
  
  it { should_not allow_mass_assignment_of(:premium) }
  it { should_not allow_mass_assignment_of(:customer_id) }
  it { should_not allow_mass_assignment_of(:last_4_digits) }
  it { should_not allow_mass_assignment_of(:card_type) }
  it { should_not allow_mass_assignment_of(:exp_month) }
  it { should_not allow_mass_assignment_of(:exp_year) }
  
  it { should allow_mass_assignment_of(:stripe_token) }
  
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
        exp_month: 4,
        exp_year: 1.year.from_now.year,
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
    
    context 'upgrade' do
      it 'success' do
        user.stripe_token = "abcd1234"
        user.upgrade
        expect(user.last_4_digits).to eql(visa[:number].slice(-4..-1))
        expect(user.card_type).to eql('Visa')
        expect(user.exp_month).to eql(visa[:exp_month])
        expect(user.exp_year).to eql(visa[:exp_year])
        expect(user.customer_id).to_not be_nil
        expect(user.stripe_token).to be_nil
        expect(user).to be_premium
        expect(user.save).to be_true
      end
      
      it 'should not upgrade to premium if stripe_token is blank' do 
        expect {
          user.upgrade
        }.to raise_error User::STRIPE_ERROR_BLANK_TOKEN
      end


      it 'should upgrade the user if already a stripe customer' do
        user.stripe_token = "abcd1234"
        user.upgrade

        expect(user).to be_premium

        user.downgrade
        user.stripe_token = "abcd1234"
        user.upgrade
        expect(user.save).to be_true
        expect(user).to be_premium
      end
      
      it 'throws Stripe::Error' do 
        Stripe::Customer.stub(:create).and_raise(Stripe::StripeError)
        
        user.stripe_token = 'abcd1234'
        expect {
          user.upgrade
        }.to raise_error Stripe::StripeError
        
        expect(user).to_not be_premium
      end
    end
    
    context 'downgrade' do
      it 'success' do 
        user.stripe_token = "abcd1234"
        user.upgrade
        expect(user.downgrade).to be_true

        expect(user.last_4_digits).to eql(visa[:number].slice(-4..-1))
        expect(user.card_type).to eql('Visa')
        expect(user.exp_month).to eql(visa[:exp_month])
        expect(user.exp_year).to eql(visa[:exp_year])
        expect(user.customer_id).to_not be_nil
        expect(user.stripe_token).to be_nil
      end
    end
  end
end