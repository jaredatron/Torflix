class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string  :name,            null: false
      t.string  :normalized_name, null: false
      t.integer :showrss_id
      t.string  :eztv_id
      t.string  :artwork_url
      t.timestamps                null: false
    end
    add_index :shows, :showrss_id,      unique: true
    add_index :shows, :eztv_id,         unique: true
    add_index :shows, :normalized_name, unique: true
  end
end
