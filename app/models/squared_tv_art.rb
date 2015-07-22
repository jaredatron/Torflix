class SquaredTvArt

  ENDPOINT = 'http://squaredtvart.tumblr.com'.freeze

  DEFAULT_SHOW_IMAGE = 'http://trevinwax.com/wp-content/uploads/2010/05/lost2_1280x1024.jpg'

  def self.get(path, params={})
    url = URI.parse(ENDPOINT)
    url.path = path
    url.query = params.to_query
    Rails.logger.warn "SquaredTvArt.get(#{url.to_s.inspect})"
    response = HTTParty.get(url, query: params)
    raise response.inspect unless response.code == 200
    response.parsed_response
  end

  def self.search(name)
    name = Rack::Utils.escape('12 monkeys')
    page = Nokogiri::HTML(get("/search/#{name}"))
    src = page.css('.ThePhoto img').first.try(:[], :src)
    src || DEFAULT_SHOW_IMAGE
  end

end
