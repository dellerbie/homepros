class SearchController < ApplicationController 
  def index
    @listings = []
    @listings = Listing.search_by_company_name(params[:q]) if params[:q].present?
    @listings = @listings.sort_by { |l| l.premium? ? 1 : 0 } 
    @listings.take((1..10).to_a.sample).each { |listing| listing.premium = true }
    
    # order by premium
  end
end