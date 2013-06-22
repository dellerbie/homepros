class SearchController < ApplicationController 
  skip_filter :hide_search
  
  def index
    @listings = []
    @listings = Listing.search_by_company_name(params[:q]).paginate(page: 1, per_page: 30) if params[:q].present?
    @total = @listings.total_entries
    @listings = @listings.sort_by { |l| l.premium? ? 0 : 1 } 
    @listings.take((1..10).to_a.sample).each { |listing| listing.premium = true }
  end
end