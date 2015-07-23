module Showrss

  ENDPOINT = 'http://showrss.info/'.freeze

  def self.get(path, params={})
    url = URI.parse(ENDPOINT)
    url.path = path
    url.query = params.to_query
    Rails.logger.warn "Showrss.get(#{path.to_s.inspect})"
    response = HTTParty.get(url, query: params)
    raise response.inspect unless response.code == 200
    response.parsed_response
  end

  def self.shows
    page = Nokogiri::HTML(get('/', cs: 'feeds'))
    options = page.css('select[name=show] option[value]')
    options.map do |option|
      {
        'showrss_id' => option[:value].to_i,
        'name'       => option.text,
      }
    end
  end

  def self.find(id)
    show = get("/feeds/#{id}.rss")["rss"]["channel"]
    episodes = show["item"]
    episodes = [] if episodes.nil?
    episodes = [episodes] if !episodes.is_a?(Array)
    episodes.map! do |episode|
      {
        'name'           => episode['title'],
        'magnet_link'    => episode['link'],
        'season_number'  =>
        'episode_number' =>
      }
    end
    {
      'name'        => show["title"].gsub('showRSS: ',''),
      'description' => show["description"].gsub('showRSS ',''),
      'link'        => show["link"],
      'episodes'    => episodes,
    }
  end

end
