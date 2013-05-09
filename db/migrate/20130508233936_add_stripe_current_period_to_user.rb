class AddStripeCurrentPeriodToUser < ActiveRecord::Migration
  def change
    add_column :users, :current_period_start, :timestamp
    add_column :users, :current_period_end, :timestamp
  end
end
