require 'spec_helper'

describe UserMailer do  
  shared_examples 'oc homepros user mailer' do
    let(:user) { FactoryGirl.create(:user, listing: FactoryGirl.create(:listing), current_period_end: Time.now) }
    let(:sender_email) { Figaro.env.mailer_email.match(/<(.*)>/)[1] }
    
    it 'sends to the correct email' do 
      mail.to.should == [user.email]
    end
    
    it 'has the correct senders email' do
      mail.from.should == [sender_email]
    end
    
    it 'has the correct bcc email' do
      mail.bcc.should == [sender_email]
    end
    
    it 'has the correct subject' do
      mail.subject.should == subject
    end
    
    it 'has content' do 
      mail.should have_body_text(text)
    end
  end
  
  describe '#welcome_email' do
    let(:mail) { UserMailer.welcome_email(user) }
    let(:subject) { '[OC HomeMasters] Welcome!' }
    let(:text) { 'Welcome to OC HomeMasters!' }
    it_behaves_like 'oc homepros user mailer'
  end
  
  describe '#downgrade_email' do
    let(:mail) { UserMailer.downgrade_email(user) }
    let(:subject) { '[OC HomeMasters] Your Listing Has Been Downgraded' }
    let(:text) { 'has been downgraded to a free listing.' }
    it_behaves_like 'oc homepros user mailer'
  end
  
  describe '#welcome_to_premium_email' do
    let(:mail) { UserMailer.welcome_to_premium_email(user) }
    let(:subject) { '[OC HomeMasters] Welcome to Premium Listings!' }
    let(:text) { 'has been upgraded to a Premium Listing.' }
    it_behaves_like 'oc homepros user mailer'
  end
  
  describe '#payment_receipt_email' do
    let(:mail) { UserMailer.payment_receipt_email(user) }
    let(:subject) { '[OC HomeMasters] Payment Receipt' }
    let(:text) { "This is a receipt for your OC HomeMaster's premium listing." }
    it_behaves_like 'oc homepros user mailer'
  end
  
  describe '#payment_failed_email' do
    let(:mail) { UserMailer.payment_failed_email(user) }
    let(:subject) { '[OC HomeMasters] Declined Payment' }
    let(:text) { 'We have been unable to charge your credit card for your premium listing' }
    it_behaves_like 'oc homepros user mailer'
  end
end