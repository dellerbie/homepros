class HomeownersController < ApplicationController 
  respond_to :json
  
  def create
    @homeowner = Homeowner.new(params[:homeowner])
    if @homeowner.save
      respond_with @homeowner, location: ''
    else 
      errors = { :errors => @homeowner.errors.full_messages }
      respond_with(errors, status: 422, location: nil)
    end
  end
end