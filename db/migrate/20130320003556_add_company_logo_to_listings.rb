class AddCompanyLogoToListings < ActiveRecord::Migration
  def change
    add_column :listings, :company_logo_photo, :string
    add_column :listings, :company_logo_photo_token, :string
  end
end
