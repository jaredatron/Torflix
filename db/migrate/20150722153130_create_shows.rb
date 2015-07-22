class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string  :name
      t.integer :showrss_info_id
      t.string  :artwork_url
      t.timestamps null: false
    end
  end
end
