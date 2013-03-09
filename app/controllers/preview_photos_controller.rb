class PreviewPhotosController < ApplicationController
  respond_to :json
  
  skip_before_filter :verify_authenticity_token
  
  def create
    @preview_photo = PreviewPhoto.new
    @preview_photo.photo = params[:user][:listing_attributes][:portfolio_photo]
    if @preview_photo.save
      render 'create', status: :ok
    else 
      render 'create', status: :unprocessable_entity
    end
  end
end