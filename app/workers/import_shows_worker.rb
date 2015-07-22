class ImportShowsWorker
  include Sidekiq::Worker

  def perform
    ShowrssInfo.shows.each do |show_info|
      begin
      show = Show.where(showrss_info_id: show_info['id']).first_or_initialize
      show.name = show_info['name']
      show.artwork_url = SquaredTvArt.search(show.name)
      show.save!

      show_info = ShowrssInfo.find(show.showrss_info_id)
      episodes = show_info['episodes'] || []
      episodes = [episodes] unless episodes.is_a? Array
      episodes.each do |episode_info|
        begin
        episode = show.episodes.where(show_rss_guid: episode_info['guid']['__content__']).first_or_initialize
        episode.show_rss_info_show_id = episode_info['showid']
        episode.name                  = episode_info['title']
        episode.published_at          = Time.parse episode_info['pubDate']
        episode.magnet_link           = episode_info['link']
        episode.save!
        rescue => e
          binding.pry
          raise
        end
      end

      rescue => e
        binding.pry
        raise
      end
    end
  end
end
