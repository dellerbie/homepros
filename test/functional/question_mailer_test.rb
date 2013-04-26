require 'test_helper'

class QuestionMailerTest < ActionMailer::TestCase
  test 'question_email' do 
    question = FactoryGirl.create(:question)

    assert ActionMailer::Base.deliveries.present?, 'no email delivered'
    
    email = ActionMailer::Base.deliveries.last
    
    assert email.body.include?(question.text)
    assert_equal [question.sender_email], email.from 
    assert_equal QuestionMailer::SUBJECT, email.subject
  end
end
