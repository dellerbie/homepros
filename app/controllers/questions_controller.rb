class QuestionsController < ApplicationController
  respond_to :json
  
  def create
    listing = Listing.find_by_id(params[:question][:listing_id])
    if listing && listing.contact_email.present?
      @question = Question.new(params[:question].except(:listing_id))
      @question.listing = listing
      if @question.save
        respond_with @question, location: ''
      else 
        errors = { :errors => @question.errors.full_messages }
        respond_with(errors, status: 422, location: nil)
      end
    else 
      errors = { :errors => ['This listing cannot receive emails'] }
      respond_with(errors, status: 422, location: nil)
    end
  end
end
