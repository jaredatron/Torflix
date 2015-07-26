@Torrentz =

  ENDPOINT: 'https://torrentz.eu'

  search: (query) ->
    Request.get("#{@ENDPOINT}/search", q: query).then(parseHTML).then (dom) ->
      results = []
      dom.find('.results > dl').each ->
        item = $(this)
        return unless item.text().includes('»')
        results.push
          id:       item.find('a').first().attr('href').slice(1)
          title:    item.find('a').first().text()
          rating:   item.find('.v').first().text()
          date:     item.find('.a').first().text()
          size:     item.find('.s').first().text()
          seeders:  item.find('.u').first().text()
          leachers: item.find('.d').first().text()
      results

  providers: (id) ->
    Request.get("#{@ENDPOINT}/#{id}").then(parseHTML).then (dom) ->
      dom.find('.download > dl > dt > a').get().map (a) ->
        a = $(a)
        name = a.find('> span').first().text()
        url  = a.attr('href')
        [name, url]

  findMagnetLink: (id) ->
    @providers(id).then (providers) ->
      console.log('FOUND PROVIDERS', providers)
      magnet_link = null
      next = ->
        return null if providers.length == 0
        [name, url] = providers.shift()
        scraper = SCRAPERS[name]
        if scraper
          console.log('TRYING PROVIDER:', name, scraper)
          return scraper.scrape(url).catch(next)
        else
          console.log('KSIPPING PROVIDER:', name)
          return next()

      next()


parseHTML = (html) ->
  div = document.createElement('div')
  div.innerHTML = html
  $(div)


Scraper = class
  constructor: (parser) ->
    @parser = parser

  scrape: (url) ->
    console.log('SCRAPING', url)
    Request.get(url).then (html) =>
      console.log('SCRAPER parsing html')
      dom = parseHTML(html)
      magnet_link = @parser(dom)
      console.log('magnet_link??', magnet_link)
      unless magnet_link
        throw new Error('unable to find magnet link at '+url)



SCRAPERS = {}
define_scraper = (name, parser) ->
  SCRAPERS[name] = new Scraper(parser)


define_scraper 'torrenthound.com', (dom) ->
  dom.find('[title="Magnet download"]').attr('href')

# define_scraper 'monova.org', ->
#   find('#download-magnet').attr('href')

define_scraper 'torrentreactor.com', (dom) ->
  dom.find('#download-magnet').attr('href')

define_scraper 'torrents.net', (dom) ->
  dom.find('.btn2-download').attr('href')


