class ListingsController < ApplicationController
  before_filter :authenticate_user!, only: [:edit, :update, :destroy]
  before_filter :find_listing, only: [:edit, :update, :destroy]
  
  PER_PAGE = 32

  CITIES = City.all.map(&:slug)
  SPECIALTIES = Specialty.all.map(&:slug)
  
  def index
    @page = (params[:page] || 1).to_i
    
    slugs
    
    @listings = parse_filter.paginate(paging_options)
    
    @base_css = 'listings-index'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @listings }
    end
  end

  def show
    @listing = Listing.find(params[:id])
    @base_css = 'show-listing'
    
    respond_to do |format|
      format.html
      format.json { render json: @listing }
    end
  end
  
  def edit
    @base_css = 'edit-listing'
  end

  def update
    respond_to do |format|
      if @listing.update_attributes(params[:listing])
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
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
  
  protected
  
  def find_listing
    @listing = current_user.listing
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
    
    scope
  end
end
