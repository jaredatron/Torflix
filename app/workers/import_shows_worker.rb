class ImportShowsWorker
  include Sidekiq::Worker

  def perform
    ShowrssInfo.shows.each do |show_info|
      showrss_info_id, name = show_info.values_at(:id, :name)
      show = Show.where(showrss_info_id: showrss_info_id).first_or_initialize
      show.name = name
      show.artwork_url = SquaredTvArt.search(name)
      show.save!
      # show_info = ShowrssInfo.find(id)

      # title
      # description
      # link
      # episodes
      # show.description =
    end
  end
end
