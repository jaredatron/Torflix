class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer  :show_id,               null: false
      t.string   :name,                  null: false
      t.string   :normalized_name,       null: false
      t.string   :magnet_link,           null: false
      t.integer  :episode_number
      t.integer  :season_number
      t.integer  :seasonal_episode_number
      t.timestamps                       null: false
    end

    add_index :episodes, [:show_id, :normalized_name], unique: true
  end
end
