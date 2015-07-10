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

  def self.providers(id)
    get("/#{id}").css('.download > dl > dt > a').map do |a|
      name = a.css('> span').first.text
      url  = a.attr('href')
      [name, url]
    end
  end

  def self.find_magnet_link(id)
    providers(id).each do |name, url|
      scraper = SCRAPERS[name] or next
      magnet_link = scraper.scrape(url)
      return magnet_link if magnet_link
    end
  end


  class Scraper
    def initialize(&parser)
      @parser = parser
    end
    def scrape(url)
      response = HTTParty.get(url)
      return nil if response.code != 200
      html = Nokogiri::HTML(response.parsed_response)
      @parser.call(html)
    end
  end

  SCRAPERS = {
    'kat.cr' => Scraper.new{|html|
      html.css('[title="Magnet link"]').first.attr(:href)
    }
  }

end