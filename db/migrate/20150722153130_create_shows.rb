class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string  :normalized_name, null: false
      t.string  :name,            null: false
      t.integer :showrss_info_id, null: false
      t.string  :artwork_url
      t.timestamps                null: false
    end
    add_index :shows, :showrss_info_id
    add_index :shows, :normalized_name, unique: true
  end
end
