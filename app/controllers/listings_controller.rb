class ListingsController < ApplicationController
  before_filter :authenticate_user!, only: [:edit, :update, :destroy]
  before_filter :find_listing, only: [:edit, :update, :destroy]
  
  PER_PAGE = 32
  
  def index
    @page = (params[:page] || 1).to_i
    
    @listings = parse_filter.paginate(paging_options)
    
    @current_city_slug = params[:city_slug] || Listing::ALL_CITIES_FILTER_KEY
    @current_specialty_slug = params[:specialty_slug] || Listing::ALL_SPECIALTIES_FILTER_KEY
    @current_budget_slug = params[:budget_slug] || Listing::ALL_BUDGETS_FILTER_KEY

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @listings }
    end
  end

  def show
    @listing = Listing.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render json: @listing }
    end
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
  
  def parse_filter
    return Listing unless params[:city_slug].present? || params[:specialty_slug].present? || params[:budget_slug].present?
    
    scope = Listing.includes(:city, :specialties)
    
    city_slug = params[:city_slug] == Listing::ALL_CITIES_FILTER_KEY ? '' : params[:city_slug]
    specialty_slug = params[:specialty_slug] == Listing::ALL_SPECIALTIES_FILTER_KEY ? '' : params[:specialty_slug]
    budget_id = params[:budget_slug] == Listing::ALL_BUDGETS_FILTER_KEY ? '' : Listing::BUDGET_SLUGS[params[:budget_slug]]
    
    scope = scope.where("cities.slug" => city_slug) if city_slug.present?
    scope = scope.where("specialties.slug" => specialty_slug) if specialty_slug.present?
    scope = scope.where("budget_id" => budget_id) if budget_id.present?
    
    scope
  end
end
