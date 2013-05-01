class UpgradesController < ApplicationController
  before_filter :authenticate_user!, only: [:edit, :update, :destroy]
  
  def new
    @hide_footer = true
    @base_css = 'upgrade'
  end
  
  def create
    current_user.stripe_token = params[:stripeToken]
    if current_user.upgrade && current_user.save
      flash[:notice] = 'Successfully upgraded your listing to premium.'
      redirect_to upgrade_path(current_user.listing)
    else 
      flash[:error] = current_user.errors.full_messages.join(' ')
      render :new
    end
  end
  
  def show
    @hide_footer = true
    @base_css = 'show-upgrade'
  end
end