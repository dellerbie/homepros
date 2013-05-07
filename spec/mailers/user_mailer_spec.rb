require 'spec_helper'

describe UserMailer do
  shared_examples 'oc homepros user mailer' do
    let(:user) { FactoryGirl.create(:user) }
    
    it 'sends to the correct email' do 
      mail.to.should == [user.email]
    end
    
    it 'has the correct senders email' do
      mail.from.should == ['slowblues@gmail.com']
    end
    
    it 'has the correct bcc email' do
      mail.bcc.should == ['slowblues@gmail.com']
    end
    
    it 'has the correct subject' do
      mail.subject.should == subject
    end
  end
  
  describe '#welcome_email' do
    let(:mail) { UserMailer.welcome_email(user) }
    let(:subject) { 'Welcome to OC Homepros!' }
    it_behaves_like 'oc homepros user mailer'
  end
  
  describe '#downgrade_email' do
    let(:mail) { UserMailer.downgrade_email(user) }
    let(:subject) { 'OC Homepros, Your Listing Will Be Downgraded' }
    it_behaves_like 'oc homepros user mailer'
  end
  
  describe '#welcome_to_premium_email' do
    let(:mail) { UserMailer.welcome_to_premium_email(user) }
    let(:subject) { 'Welcome to OC Homepros Premium Listings!' }
    it_behaves_like 'oc homepros user mailer'
  end
end