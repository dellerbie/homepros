require 'spec_helper'

describe QuestionsController do
  it 'should successfully email a question' do
    question = FactoryGirl.attributes_for(:question)
    question[:listing_id] = FactoryGirl.create(:listing).id
    
    expect {
      post :create, question: question, format: :json
    }.to change { Question.count }
    
    expect(response).to be_success
  end
  
  it 'should be unsuccessful' do
    expect {
      post :create, question: {}, format: :json
    }.to_not change { Question.count }

    expect(response.code).to eql('422')
  end
  
  it 'invalid question' do 
    expect {
      post :create, question: {listing_id: FactoryGirl.create(:listing).id}, format: :json
    }.to_not change { Question.count }
    
    errors = { errors: ["Sender email can't be blank", "Text can't be blank"] }
    
    expect(response.body).to eql(errors.to_json)
    expect(response.code).to eql('422')
  end
  
  it 'invalid listing' do
    question = FactoryGirl.attributes_for(:question)
    
    expect {
      post :create, question: {listing_id: 123, text: question['text'], sender_email: question['sender_email']}, format: :json
    }.to_not change { Question.count }
    
    errors = { errors: ['This listing cannot receive emails'] }
    
    expect(response.body).to eql(errors.to_json)
    expect(response.code).to eql('422')
  end
end