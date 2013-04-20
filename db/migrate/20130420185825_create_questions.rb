class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer   :listing_id
      t.string    :sender_email
      t.text      :text
      t.timestamps
    end
  end
end
