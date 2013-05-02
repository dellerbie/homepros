class AddIndexToListingSpecialties < ActiveRecord::Migration
  def change
    add_index :listings_specialties, [:listing_id, :specialty_id], unique: true
  end
end
