class CreatePreviewPhotos < ActiveRecord::Migration
  def change
    create_table :preview_photos do |t|
      t.string :token
      t.string :photo

      t.timestamps
    end
  end
end
