class PreviewPhotosController < ApplicationController
  respond_to :json
  
  skip_before_filter :verify_authenticity_token
  
  def create
    @preview_photo = PreviewPhoto.new
    photo = nil
    company_logo = false
    
    # these first two blocks are for the edit listing form
    if params[:listing] && params[:listing][:portfolio_photo]
      photo = params[:listing][:portfolio_photo]
    elsif params[:listing] && params[:listing][:company_logo_photo]
      photo = params[:listing][:company_logo_photo]
      company_logo = true
    else
      # this is for the registration form
      photo = params[:user][:listing_attributes][:portfolio_photos_attributes]['0'][:portfolio_photo]
    end
    
    @preview_photo.photo = photo
    if @preview_photo.save
      render 'create', status: :ok
    else 
      render 'create', status: :unprocessable_entity
    end
  end
end