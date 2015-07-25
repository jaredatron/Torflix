module Eztv

  ENDPOINT = HttpEndpoint.new('https://eztv.ch/')

  def self.shows
    page = ENDPOINT.get_html('/showlist/')
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
    link = ENDPOINT.url_for("/shows/#{id}/")
    page = ENDPOINT.get_html("/shows/#{id}/")

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
