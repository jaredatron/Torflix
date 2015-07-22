class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string  :name,            null: false
      t.integer :showrss_info_id, null: false
      t.string  :artwork_url
      t.timestamps                null: false
    end
    add_index :shows, :showrss_info_id
  end
end
