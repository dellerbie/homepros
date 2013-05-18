class PreviewPhotosController < ApplicationController
  respond_to :json
  
  skip_before_filter :verify_authenticity_token
  
  def create
    puts ""
    @preview_photo = PreviewPhoto.new
    photo = nil
    company_logo = false
    
    if params[:listing] && params[:listing][:portfolio_photo]
      photo = params[:listing][:portfolio_photo]
    elsif params[:listing] && params[:listing][:company_logo_photo]
      photo = params[:listing][:company_logo_photo]
      company_logo = true
    else
      photo = params[:user][:listing_attributes][:portfolio_photos_attributes]['0'][:portfolio_photo]
    end
    
    puts "photo => "
    p photo
    
    @preview_photo.photo = photo
    if @preview_photo.save
      if company_logo
        session[:logo_photo_url] = @preview_photo.photo_url(:logo)
      else
        session[:preview_photo_url] = @preview_photo.photo_url
        puts "session[:preview_photo_url] => #{session[:preview_photo_url]}"
      end
      render 'create', status: :ok
    else 
      render 'create', status: :unprocessable_entity
    end
  end
end