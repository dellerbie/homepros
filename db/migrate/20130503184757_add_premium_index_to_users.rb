class AddPremiumIndexToUsers < ActiveRecord::Migration
  def change
    add_index(:users, :premium, unique: false)
  end
end
