class AddSlugToListing < ActiveRecord::Migration
  def change
    add_column :listings, :slug, :string, null: false
    add_index :listings, :slug, unique: true
  end
end
