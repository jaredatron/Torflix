class ImportShowsWorker
  include Sidekiq::Worker

  def perform
    show = Showrss.shows + Eztv.shows

    show.each do |show_info|
      show = Show.by_name(show_info['name']).first_or_initialize
      # show = Show.where(showrss_info_id: show_info['id']).first_or_initialize
      show.showrss_id  = show_info['showrss_id']
      show.eztv_id     = show_info['eztv_id']
      show.name        = show_info['name']
      show.artwork_url = SquaredTvArt.search(show.name)
      show.save!

      show_info = Showrss.find(show.showrss_id)
      episodes = show_info['episodes'] || []
      episodes = [episodes] unless episodes.is_a? Array
      episodes.each do |episode_info|
        episode = show.episodes.by_name(episode_info['name']).first_or_initialize
        episode.name        = episode_info['name']
        episode.magnet_link = episode_info['magnet_link']
        episode.save!
      end
    end
  end
end
