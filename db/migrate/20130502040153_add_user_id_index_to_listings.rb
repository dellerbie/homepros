class AddUserIdIndexToListings < ActiveRecord::Migration
  def change
    add_index :listings, :user_id, unique: true
  end
end
