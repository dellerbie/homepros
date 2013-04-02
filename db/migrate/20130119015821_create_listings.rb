class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer   :user_id
      t.string    :company_name
      t.string    :company_logo
      t.integer   :budget_id
      t.string    :state
      t.string    :contact_email
      t.string    :website
      t.integer   :phone_area_code
      t.integer   :phone_exchange
      t.integer   :phone_suffix
      t.string    :portfolio_photo_description

      t.timestamps
    end
  end
end
