class RegistrationsController < Devise::RegistrationsController
  
  def new
    @listing = Listing.new
    super
  end
  
end