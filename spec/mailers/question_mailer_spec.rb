require 'spec_helper'

describe QuestionMailer do
  shared_examples 'oc homepros question mailer' do
    let(:question) { FactoryGirl.create(:question) }
    let(:sender_email) { Figaro.env.mailer_email.match(/<(.*)>/)[1] }
    
    it 'sends to the correct email' do 
      mail.to.should == [question.listing.contact_email]
    end
    
    it 'has the correct senders email' do
      mail.from.should == [sender_email]
    end
    
    it 'has the correct subject' do
      mail.subject.should == subject
    end
  end
  
  describe '#welcome_email' do
    let(:mail) { QuestionMailer.question_email(question) }
    let(:subject) { QuestionMailer::SUBJECT }
    it_behaves_like 'oc homepros question mailer'
  end
end