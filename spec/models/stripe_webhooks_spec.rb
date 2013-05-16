require 'spec_helper'

describe StripeWebhooks do
  let(:user) { FactoryGirl.create(:user, listing: FactoryGirl.create(:listing)) }
  
  before(:each) do
    successful_stripe_response = StripeHelper::Response.new("customer_success")
    successful_stripe_response.stub(:update_subscription).and_return(nil)
    successful_stripe_response.stub(:cancel_subscription).and_return(nil)
    Stripe::Customer.stub(:create).and_return(successful_stripe_response)
    Stripe::Customer.stub(:retrieve).and_return(successful_stripe_response)
  end
  
  describe 'subscription canceled' do
    before(:each) do 
      user.upgrade
      user.downgrade
      user.reload
    end
    
    it 'removes premium from user' do 
      expect(user).to be_premium
      
      expect {
        StripeWebhooks.subscription_deleted(user.customer_id)
        user.reload
      }.to change {user.premium?}
    end
    
    it 'sets pending_downgrade to false' do
      expect(user).to be_pending_downgrade
      
      expect {
        StripeWebhooks.subscription_deleted(user.customer_id)
        user.reload
      }.to change {user.pending_downgrade?}
    end
    
    it 'does nothing if the user isnt found' do
      expect {
        StripeWebhooks.subscription_deleted('blahblah')
      }.to_not raise_error
    end
  end
end