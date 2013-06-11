require 'spec_helper'

describe HomeownersController do
  it 'should successfully create a homeowner' do
    homeowner = FactoryGirl.attributes_for(:homeowner)
    homeowner[:city_id] = homeowner[:city].id
    homeowner.delete(:city)
    
    expect {
      post :create, homeowner: homeowner, format: :json
    }.to change { Homeowner.count }
    
    expect(response).to be_success
  end
  
  it 'should be unsuccessful' do
    expect {
      post :create, homeowner: {}, format: :json
    }.to_not change { Homeowner.count }
  
    expect(response.code).to eql('422')
  end
end