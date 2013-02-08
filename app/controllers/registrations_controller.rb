class RegistrationsController < Devise::RegistrationsController 
  
  def new
    resource = build_resource({})
    resource.build_listing 
    respond_with resource
  end
  
end