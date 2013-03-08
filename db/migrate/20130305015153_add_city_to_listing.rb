class AddCityToListing < ActiveRecord::Migration
  def change
    add_column :listings, :city_id, :integer
  end
end
