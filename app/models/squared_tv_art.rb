class SquaredTvArt

  ENDPOINT = HttpEndpoint.new('http://squaredtvart.tumblr.com')

  def self.search(name)
    name = Rack::Utils.escape(name)
    page = ENDPOINT.get_html("/search/#{name}"))
    page.css('.ThePhoto img').first.try(:[], :src)
  end

end
