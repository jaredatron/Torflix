class Torrent

  ENDPOINT = 'http://torrentz.eu/search'.freeze

  def self.search(query)
    url = URI.parse(ENDPOINT)
    url.query = {q: query}.to_query
    response = HTTParty.get(url)
    # raise response.inspect unless response.code == 200
    html = Nokogiri::HTML(response.parsed_response)
    
    entries = []
    html.css('.results > dl').each do |item|
      next unless item.text.include? '»'
      entries.push(
        id:       item.css('a').first.attr('href').slice(1),
        title:    item.css('a').first.text,
        rating:   item.css('.v').first.text,
        date:     item.css('.a').first.text,
        size:     item.css('.s').first.text,
        seeders:  item.css('.u').first.text,
        leachers: item.css('.d').first.text,
      )
    end

    entries
  end

end