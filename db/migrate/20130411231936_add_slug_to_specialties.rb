class AddSlugToSpecialties < ActiveRecord::Migration
  def change
    add_column :specialties, :slug, :string, null: false
    add_index :specialties, :slug, unique: true
  end
end
