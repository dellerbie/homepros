class AddSlugToSpecialties < ActiveRecord::Migration
  def change
    add_column :specialties, :slug, :string
    add_index :specialties, :slug
  end
end
