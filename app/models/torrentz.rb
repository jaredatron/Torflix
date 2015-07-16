class Torrentz

  ENDPOINT = 'https://torrentz.eu/'.freeze

  def self.get(path, params={})
    url = URI.parse(ENDPOINT)
    url.path = path
    url.query = params.to_query
    Rails.logger.warn "Torrentz.get(#{url.to_s.inspect})"
    response = HTTParty.get(url, query: params)
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
      if magnet_link
        puts "MAGNET FOUND FROM #{name}"
      end
      return magnet_link if magnet_link
    end
  end


  class Scraper
    def self.scrape(url)
      new(url).scrape
    end
    def self.domain(domain=nil)
      @domain = domain unless domain.nil?
      @domain
    end
    attr_reader :url, :respomse, :html, :document
    def initialize(url)
      @url = url
    end
    def find(css)
      document.css(css).first
    end
    def url_for(path)
      "://#{self.class.domain}#{path}"
    end
    def scrape
      @response = HTTParty.get(url)
      return nil if @response.code != 200
      @html = @response.parsed_response
      @document = Nokogiri::HTML(@html)
      parse
    end
  end

  SCRAPERS = {}

  def self.define_scraper(domain, &block)
    scraper = Class.new(Scraper)
    scraper.send :define_method, :parse, &block
    scraper.domain(domain)
    SCRAPERS[domain] = scraper
  end

  # define_scraper 'kat.cr' do
  #   find('[title="Magnet link"]').attr(:href)
  # end

  # define_scraper 'thepiratebay.se' do
  #   binding.pry
  # end

  define_scraper 'torrenthound.com' do
    find('[title="Magnet download"]').attr('href')
  end

  # define_scraper 'yourbittorrent.com' do
  #   NO MAGNET LINK
  # end

  define_scraper 'monova.org' do
    find('#download-magnet').attr(:href)
  end

  define_scraper 'torrentreactor.com' do
    find('#download-magnet').attr(:href)
  end

  # define_scraper 'seedpeer.me' do
  #   binding.pry
  # end

  # define_scraper 'torrentdownloads.me' do
  #   binding.pry
  # end

  define_scraper 'torrents.net' do
    find('.btn2-download')[:href]
  end

  # define_scraper 'torrentfunk.com' do
  #   binding.pry
  # end

  # define_scraper 'limetorrents.cc' do
  #   binding.pry
  # end

  # define_scraper 'isohunt.to' do
  #   binding.pry
  # end

  # define_scraper 'torrentproject.se' do
  #   binding.pry
  # end

end
