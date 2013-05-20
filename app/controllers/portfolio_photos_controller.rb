class PortfolioPhotosController < ApplicationController
  respond_to :json
  
  before_filter :authenticate_user!
  before_filter :find_listing
  skip_before_filter :verify_authenticity_token
  
  def create
    max_photos = @listing.premium? ? Listing::MAX_PREMIUM_PHOTOS : Listing::MAX_FREE_PHOTOS
    @portfolio_photo = @listing.portfolio_photos.new(params[:portfolio_photo])
    
    if @listing.can_add_photos? && @portfolio_photo.save
      render 'create', status: :ok, formats: [:html]
    elsif !@listing.can_add_photos?
      @portfolio_photo.errors.add(:base, "You cannot have more than #{max_photos} photos")
      render 'create', status: :unprocessable_entity, formats: [:html]
    else 
      render 'create', status: :unprocessable_entity, formats: [:html]
    end
  end
  
  def update
    @portfolio_photo = @listing.portfolio_photos.find(params[:id])
    if @portfolio_photo.update_attributes(params[:portfolio_photo])
      render 'create', status: :ok, formats: [:html]
    else
      render 'create', status: :unprocessable_entity, formats: [:html]
    end
  end
  
  private
  
  def find_listing
    @listing = current_user.listing
  end
end