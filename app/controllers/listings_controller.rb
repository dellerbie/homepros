class ListingsController < ApplicationController
  include Devise::Controllers::Helpers
  
  before_filter :authenticate_user!, only: [:edit, :update, :destroy]
  before_filter :find_current_user_listing, only: [:edit, :update, :destroy]
  before_filter :find_listing, only: [:claim]
  
  PER_PAGE = 32

  CITIES = City.all.map(&:slug)
  SPECIALTIES = Specialty.all.map(&:slug)
  
  def index
    @page = (params[:page] || 1).to_i
    
    slugs
    
    @listings = parse_filter.paginate(paging_options)
    
    # for now, show the first few listings as premium no matter what
    # this is to entice business owners to upgrade to premium
    if @page == 1 
      @listings.take((1..10).to_a.sample).each { |listing| listing.premium = true }
    end
    
    @base_css = 'listings-index'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @listings }
    end
  end

  def show
    @listing = Listing.find(params[:id])
    @question = Question.new
    @question.listing = @listing
    @base_css = 'show-listing'
    
    respond_to do |format|
      format.html
      format.json { render json: @listing }
    end
  end
  
  def edit
    @base_css = 'edit-listing'
    @container_css = 'premium' if @listing.premium?
    @hide_footer = true
    if @listing.premium?
      n_photos = @listing.portfolio_photos.length
      (Listing::MAX_PREMIUM_PHOTOS - n_photos).times { @listing.portfolio_photos.build }
    end
  end

  def update
    respond_to do |format|
      if @listing.update_attributes(params[:listing])
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { render 'photos', status: :ok }
      else
        format.html { render action: "edit" }
        format.json { render 'photos', status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @listing.destroy

    respond_to do |format|
      format.html { redirect_to listings_url }
      format.json { head :no_content }
    end
  end
  
  def claim
    @base_css = 'claim-listing'
    @hide_footer = true
    
    if request.get?
      @user = User.new
    else
      if @listing.claimable?
        @user = User.new(params[:user])
        @listing.claimable = false
        @user.listing = @listing
    
        if @user.save
          sign_in(:user, @user)
          flash.notice = "You have successfully claimed this profile. Click 'Edit' to make changes to the listing."
          redirect_to new_upgrade_path
        else 
          @user.clean_up_passwords if @user.respond_to?(:clean_up_passwords)
        end
      else 
        flash.alert = "This listing can't be claimed"
        redirect_to listing_path(@listing)
      end
    end
  end
  
  protected
  
  def find_current_user_listing
    @listing = current_user.listing
  end
  
  def find_listing
    @listing = Listing.find(params[:id])
  end
  
  def paging_options 
    {
      :page => @page, 
      :per_page => PER_PAGE
    }
  end
  
  def slugs
    city_slug, specialty_slug = params[:city_slug], params[:specialty_slug]
    
    @current_city_slug = Listing::ALL_CITIES_FILTER_KEY
    @current_specialty_slug = Listing::ALL_SPECIALTIES_FILTER_KEY

    if city_slug.present? && specialty_slug.blank?
      if CITIES.include?(city_slug) 
        @current_city_slug = city_slug
      elsif SPECIALTIES.include?(city_slug)
        @current_specialty_slug = city_slug
      end
    elsif city_slug.present? && specialty_slug.present?
      @current_city_slug = city_slug
      @current_specialty_slug = specialty_slug
    end
  end
  
  def parse_filter
    return Listing unless @current_city_slug.present? || @current_specialty_slug.present?
    
    scope = Listing
    
    city_slug = @current_city_slug == Listing::ALL_CITIES_FILTER_KEY ? '' : @current_city_slug
    specialty_slug = @current_specialty_slug == Listing::ALL_SPECIALTIES_FILTER_KEY ? '' : @current_specialty_slug
    
    scope = scope.where("cities.slug" => city_slug) if city_slug.present?
    scope = scope.where("specialties.slug" => specialty_slug) if specialty_slug.present?
    
    scope = scope.joins("LEFT JOIN users ON listings.user_id = users.id").order("users.premium, RANDOM()") if city_slug.blank? && specialty_slug.blank?
    
    scope
  end
end
