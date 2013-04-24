class AddClaimableToListings < ActiveRecord::Migration
  def change
    add_column :listings, :claimable, :boolean, default: false
  end
end
