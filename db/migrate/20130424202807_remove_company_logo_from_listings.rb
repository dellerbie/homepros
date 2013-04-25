class RemoveCompanyLogoFromListings < ActiveRecord::Migration
  def up
    remove_column :listings, :company_logo
  end
  
  def down
    add_column :listings, :company_logo, :string
  end
end
