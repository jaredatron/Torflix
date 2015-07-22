module ShowrssInfo

  ENDPOINT = 'http://showrss.info/'.freeze

  def self.get(path, params={})
    url = URI.parse(ENDPOINT)
    url.path = path
    url.query = params.to_query
    Rails.logger.warn "ShowrssInfo.get(#{url.to_s.inspect})"
    response = HTTParty.get(url, query: params)
    raise response.inspect unless response.code == 200
    response.parsed_response
  end

  def self.shows
    page = Nokogiri::HTML(get('/', cs: 'feeds'))
    options = page.css('select[name=show] option[value]')
    shows = options.map do |option|
      {
        id: option[:value].to_i,
        name: option.text,
      }
    end
  end

  def self.find(id)
    show = get("/feeds/#{id}.rss")["rss"]["channel"]
    {
      title: show["title"].gsub('showRSS: ',''),
      description: show["description"].gsub('showRSS ',''),
      link: show["link"],
      episodes: show["item"],
    }
  end

end
