class RegistrationsController < Devise::RegistrationsController 
  
  before_filter :set_css, except: [:edit, :update]
  before_filter :hide_elements
  
  def new
    resource = build_resource({})
    listing = resource.build_listing 
    Listing::MAX_FREE_PHOTOS.times { listing.portfolio_photos.build }
    respond_with resource
  end
  
  protected
  
  def set_css
    @base_css = 'new-listing'
  end
  
  def hide_elements
    @hide_get_listed_btn = true
    @hide_footer = true
  end
  
  def after_sign_up_path_for(resource)
    new_upgrade_path
  end
  
end