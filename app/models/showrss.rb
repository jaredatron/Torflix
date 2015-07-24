module Showrss

  ENDPOINT = HttpEndpoint.new('http://showrss.info/')

  def self.shows
    page = Nokogiri::HTML(ENDPOINT.get('/', cs: 'feeds'))
    options = page.css('select[name=show] option[value]')
    options.map do |option|
      {
        'showrss_id' => option[:value].to_i,
        'name'       => option.text,
      }
    end
  end

  def self.find(id)
    show = ENDPOINT.get("/feeds/#{id}.rss")["rss"]["channel"]
    episodes = show["item"]
    episodes = [] if episodes.nil?
    episodes = [episodes] if !episodes.is_a?(Array)
    episodes.map! do |episode|
      {
        'name'           => episode['title'],
        'magnet_link'    => episode['link'],
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
