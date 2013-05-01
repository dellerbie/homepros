class AddPendingDowngradeToUser < ActiveRecord::Migration
  def change
    add_column :users, :pending_downgrade, :boolean, default: false
  end
end
