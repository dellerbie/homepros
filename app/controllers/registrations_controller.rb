class RegistrationsController < Devise::RegistrationsController 
  
  def new
    @base_css = 'new-listing'
    resource = build_resource({})
    resource.build_listing 
    respond_with resource
  end
  
end