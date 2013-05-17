class RemovePortfolioPhotoFromListing < ActiveRecord::Migration
  def up
    remove_column :listings, :portfolio_photo
    remove_column :listings, :portfolio_photo_token
    remove_column :listings, :portfolio_photo_description
  end
  
  def down
    add_column :listings, :portfolio_photo
    add_column :listings, :portfolio_photo_token
    add_column :listings, :portfolio_photo_description
  end
end
