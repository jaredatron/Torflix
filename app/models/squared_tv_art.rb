class SquaredTvArt

  ENDPOINT = HttpEndpoint.new('http://squaredtvart.tumblr.com')

  def self.search(name)
    name = Rack::Utils.escape(name)
    page = Nokogiri::HTML(ENDPOINT.get("/search/#{name}"))
    page.css('.ThePhoto img').first.try(:[], :src)
  end

end
