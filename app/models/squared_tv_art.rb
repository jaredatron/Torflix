class SquaredTvArt

  ENDPOINT = 'http://squaredtvart.tumblr.com'.freeze

  def self.get(path, params={})
    url = URI.parse(ENDPOINT)
    url.path = path
    url.query = params.to_query
    Rails.logger.warn "SquaredTvArt.get(#{url.to_s.inspect})"
    response = HTTParty.get(url, query: params)
    raise response.inspect unless response.code == 200
    response.parsed_response
  rescue SocketError
    retry
  end

  def self.search(name)
    name = Rack::Utils.escape(name)
    page = Nokogiri::HTML(get("/search/#{name}"))
    page.css('.ThePhoto img').first.try(:[], :src)
  end

end
