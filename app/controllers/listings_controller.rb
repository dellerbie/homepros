class ListingsController < ApplicationController
  include Devise::Controllers::Helpers
  
  before_filter :authenticate_user!, only: [:edit, :update, :destroy]
  before_filter :find_current_user_listing, only: [:edit, :update, :destroy]
  before_filter :find_listing, only: [:claim, :show]
  before_filter :homeowner, only: [:index, :show]
  skip_filter :hide_search, only: [:index]
  
  PER_PAGE = 32

  CITIES = City.all.map(&:slug)
  SPECIALTIES = Specialty.all.map(&:slug)
  
  def index
    @page = (params[:page] || 1).to_i
    
    parse_slugs
    
    @listings = Listing.filter(@current_city_slug, @current_specialty_slug, paging_options)
    
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
    @question = Question.new
    @question.listing = @listing
    @base_css = 'show-listing'
    
    session[:last_page] = request.env['HTTP_REFERER'] || root_url
    
    respond_to do |format|
      format.html
      format.json { render json: @listing }
    end
  end
  
  def edit
    @base_css = 'edit-listing'
    @container_css = 'premium' if @listing.premium?
    @hide_footer = true
    @listing.build_portfolio_photos if @listing.premium?
  end

  def update
    @base_css = 'edit-listing'
    @container_css = 'premium' if @listing.premium?
    @hide_footer = true
    
    respond_to do |format|
      if @listing.update_attributes(params[:listing])
        format.html { redirect_to @listing, notice: 'Your listing was successfully updated.' }
        format.json { render 'photos', status: :ok }
      else
        @listing.build_portfolio_photos if @listing.premium?
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
  
  def parse_slugs
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
  
  def homeowner
    @homeowner = Homeowner.new
  end
end
