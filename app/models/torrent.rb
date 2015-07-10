class Torrent

  def self.search(query)
    html = Torrentz.get('/search', q: query)
    
    entries = []
    html.css('.results > dl').each do |item|
      next unless item.text.include? '»'
      entries.push(
        id:       item.css('a').first.attr('href').slice(1..-1),
        title:    item.css('a').first.try(:text),
        rating:   item.css('.v').first.try(:text),
        date:     item.css('.a').first.try(:text),
        size:     item.css('.s').first.try(:text),
        seeders:  item.css('.u').first.try(:text),
        leachers: item.css('.d').first.try(:text),
      )
    end

    entries
  end

  def self.find(id)
    {
      id: id, 
      magnet_link: Torrentz.find_magnet_link(id),
    }
  end

end