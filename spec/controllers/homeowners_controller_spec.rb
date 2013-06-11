require 'spec_helper'

describe HomeownersController do
  it 'should successfully create a homeowner' do
    homeowner = FactoryGirl.attributes_for(:homeowner)
    homeowner[:city_id] = FactoryGirl.create(:city).id
    
    expect {
      post :create, homeowner: homeowner, format: :json
    }.to change { Homeowner.count }
    
    expect(response).to be_success
  end
  
  # it 'should be unsuccessful' do
  #   expect {
  #     post :create, question: {}, format: :json
  #   }.to_not change { Question.count }
  # 
  #   expect(response.code).to eql('422')
  # end
  # 
  # it 'invalid email' do 
  #   expect {
  #     post :create, question: {listing_id: FactoryGirl.create(:listing).id}, format: :json
  #   }.to_not change { Question.count }
  #   
  #   errors = { errors: ["Sender email can't be blank", "Text can't be blank"] }
  #   
  #   expect(response.body).to eql(errors.to_json)
  #   expect(response.code).to eql('422')
  # end
end