class AddStripeToUser < ActiveRecord::Migration
  def change
    add_column :users, :customer_id, :string
    add_column :users, :last_4_digits, :string
    add_column :users, :card_type, :string
    add_column :users, :exp_month, :string
    add_column :users, :exp_year, :string
    add_index :users, :customer_id
  end
end
