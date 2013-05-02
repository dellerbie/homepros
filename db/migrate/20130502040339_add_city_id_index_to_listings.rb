class AddCityIdIndexToListings < ActiveRecord::Migration
  def change
    add_index :listings, :city_id, unique: false
  end
end
