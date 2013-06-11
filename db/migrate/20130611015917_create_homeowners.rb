class CreateHomeowners < ActiveRecord::Migration
  def change
    create_table :homeowners do |t|
      t.integer :city_id
      t.string  :email
      t.boolean  :received_flier, default: false
      t.timestamps
    end
    
    add_index :homeowners, :email, unique: true
  end
end
