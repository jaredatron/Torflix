class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string   :show_rss_guid,         null: false
      t.integer  :show_id,               null: false
      t.string   :name,                  null: false
      t.integer  :show_rss_info_show_id, null: false
      t.datetime :published_at,          null: false
      t.string   :magnet_link,           null: false
      t.timestamps                       null: false
    end

    add_index :episodes, :show_rss_guid, unique: true
    add_index :episodes, :show_id
  end
end
