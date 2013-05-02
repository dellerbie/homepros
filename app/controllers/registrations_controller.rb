class RegistrationsController < Devise::RegistrationsController 
  
  before_filter :set_css
  
  def new
    resource = build_resource({})
    resource.build_listing 
    respond_with resource
  end
  
  def edit
    @base_css = ''
    super
  end
  
  protected
  
  def set_css
    @base_css = 'new-listing'
    @hide_get_listed_btn = true
    @hide_footer = true
  end
  
  def after_sign_up_path_for(resource)
    new_upgrade_path
  end
  
end