class CreatePortfolioPhotos < ActiveRecord::Migration
  def change
    create_table :portfolio_photos do |t|
      t.integer :listing_id
      t.string  :portfolio_photo
      t.string  :portfolio_photo_token
      t.string  :description
      t.timestamps
    end
  end
end
