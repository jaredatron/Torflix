module Eztv

  ENDPOINT = 'https://eztv.ch/'.freeze

  def self.url_for_path(path, params={})
    url = URI.parse(ENDPOINT)
    url.path = path
    url.query = params.to_query
    url.to_s
  end

  def self.get(path, params={})
    url = url_for_path(path, params)
    Rails.logger.warn "Eztv.get(#{path.to_s.inspect})"
    response = HTTParty.get(url, query: params)
    binding.pry unless response.code == 200
    raise response.inspect unless response.code == 200
    response.parsed_response
  end

  def self.shows
    page = Nokogiri::HTML(get('/showlist/'))
    trs = page.css('.forum_header_border tr').to_a
    trs.reject! do |tr|
      tr.css('.forum_thread_post').blank?
    end
    trs.map do |tr|
      image_tr, name_tr, status_tr, votes_tr = tr.css('> td')
      name = name_tr.text
      show_page_path = name_tr.css('a.thread_link').first[:href]
      id = show_page_path.match(%r{^/shows/(.+)/$})[1]
      # show_page_url = "#{ENDPOINT}#{show_page_path.slice(1..-1)}"
      {
        'eztv_id' => id,
        'name'    => name,
      }
    end
  end

  def self.find(id)
    link = url_for_path("/shows/#{id}/")
    page = Nokogiri::HTML(get("/shows/#{id}/"))

    name = page.css('.section_post_header:contains("Show Information:") b').first.text

    trs = page.css('tr.forum_header_border').to_a
    trs.reject!{ |tr| tr.css(".epinfo").blank? }
    episodes = trs.map do |tr|
      name = tr.css('a.epinfo').first.try(:[], :title)
      magnet_link = tr.css('a.magnet').first.try(:[],:href)
      {
        'name'        => name,
        'magnet_link' => magnet_link,
      }
    end

    description = page.css('.show_info_description').first.text

    {
      'name'        => name,
      'description' => description,
      'link'        => link,
      'episodes'    => episodes,
    }
  end

end
