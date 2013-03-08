class CreateListingsSpecialties < ActiveRecord::Migration
  def change
    create_table :listings_specialties do |t|
      t.integer :listing_id
      t.integer :specialty_id
    end
  end
end
