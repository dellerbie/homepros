require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  test 'should successfully email a question' do
    question = FactoryGirl.attributes_for(:question)
    question[:listing_id] = FactoryGirl.create(:listing).id
    
    assert_difference('Question.count') do 
      post :create, question: question, format: :json
    end
    
    assert_response :success
  end
  
  test 'un-emailable listing' do
    assert_no_difference('Question.count') do 
      post :create, question: {}, format: :json
    end
    
    assert_response 422
  end
  
  test 'invalid question' do 
    assert_no_difference('Question.count') do 
      post :create, question: {listing_id: FactoryGirl.create(:listing).id}, format: :json
    end
    
    errors = { errors: ["Sender email can't be blank", "Text can't be blank"] }
    
    assert_equal errors.to_json, @response.body
    
    assert_response 422
  end
  
  test 'invalid listing' do
    question = FactoryGirl.attributes_for(:question)
    
    assert_no_difference('Question.count') do 
      post :create, question: {listing_id: 123, text: question['text'], sender_email: question['sender_email']}, format: :json
    end
    
    errors = { errors: ['This listing cannot receive emails'] }
    
    assert_equal errors.to_json, @response.body
    
    assert_response 422
  end
end
