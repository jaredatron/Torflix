class Torrentz

  ENDPOINT = 'http://torrentz.eu/'.freeze

  def self.get(path, params={})
    url = URI.parse(ENDPOINT)
    url.path = path
    url.query = params.to_query
    response = HTTParty.get(url)
    raise response.inspect unless response.code == 200
    Nokogiri::HTML(response.parsed_response)
  end

  def providers(id)
    get("/#{id}").css('.download > dl > dt > a').map do |a|
      {
        name: a.css('> span').first.text,
        url:  a.attr('href'),
      }
    end
  end

  def find_magnet_link(id)
    providers(id).find do |provider|
      binding.pry
    end
  end

end