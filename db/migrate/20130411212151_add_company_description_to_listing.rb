class AddCompanyDescriptionToListing < ActiveRecord::Migration
  def change
    add_column :listings, :company_description, :text
  end
end
