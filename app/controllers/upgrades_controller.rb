class UpgradesController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    redirect_to listing_path(current_user.listing) if current_user.premium?
    @hide_footer = true
    @base_css = 'upgrades'
  end
  
  def create
    current_user.stripe_token = params[:stripeToken]
    if current_user.upgrade
      redirect_to upgrade_path(current_user.listing)
    else 
      flash[:error] = current_user.errors.full_messages.join(' ')
      render :new
    end
  end
  
  def show
    @hide_footer = true
    @base_css = 'successful-upgrade'
  end
  
  def update
    current_user.stripe_token = params[:stripeToken]
    if current_user.update_card
      flash[:notice] = 'Successfully updated your credit card.'
      redirect_to edit_user_registration_path
    else 
      flash[:error] = current_user.errors.full_messages.join(' ')
      redirect_to edit_user_registration_path
    end
  end
  
  def destroy
    if current_user.downgrade
      flash[:notice] = 'Successfully downgraded your listing. Your listing will remain a premium listing until the end of the pay period.'
      redirect_to edit_user_registration_path
    else 
      flash[:error] = current_user.errors.full_messages.join(' ')
      redirect_to edit_user_registration_path
    end
  end
end