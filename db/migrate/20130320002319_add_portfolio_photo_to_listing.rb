class AddPortfolioPhotoToListing < ActiveRecord::Migration
  def change
    add_column :listings, :portfolio_photo, :string
    add_column :listings, :portfolio_photo_token, :string
  end
end
