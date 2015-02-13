cheerio     = require 'cheerio'
Request     = require 'request'
querystring = require 'querystring'

request = (url, callback) ->
  console.log("GET #{url}")
  options =
    url: url,
    headers: {'user-agent': 'Mozilla/5.0'},
    gzip: true,

  Request(options, callback)


search = (query, callback) ->
  url = "http://torrentz.eu/search?#{querystring.stringify(q: query)}"

  request url, (error, response, body) ->
    return callback(error, null) if error
    $ = cheerio.load body
    entries = []
    $('.results > dl').each (i, item) ->
      item = $(item)
      return if item.text().indexOf('»') == -1
      entries.push
        id:          item.find('a').attr('href').slice(1)
        title:       item.find('a').text()
        rating:      Number(item.find('.v').text())
        date:        item.find('.a').text()
        size:        item.find('.s').text()
        seeders:     Number(item.find('.u').text())
        leachers:    Number(item.find('.d').text())

    callback(null, entries)

getProviders = (id, callback) ->
  url = "http://torrentz.com/#{id}"
  request url, (error, response, body) ->
    return callback(error, null) if error
    $ = cheerio.load body
    providers = []
    $('.download > dl > dt > a').each (i, a) ->
      a = $(a)
      providers.push
        name: a.find('> span').first().text()
        url:  a.attr('href')
    callback(null, providers)


PROVIDERS =
  'kickass.to': (url, callback) ->
    request url, (error, response, body) ->
      return callback(error, null) if error
      $ = cheerio.load body
      magnetLink = $('a[title="Magnet link"]').attr('href')
      magnetLink ||= $('a.magnetlinkButton').attr('href')
      callback(null, magnetLink)


  'thepiratebay.se': (url, callback) ->
    null


  'monova.org': (url, callback) ->
    null


getMagnetLink = (id, callback) ->
  getProviders id, (error, providers) ->
    return callback(error, null) if error

    provider = null
    for name of PROVIDERS
      providers.forEach (p) -> provider ||= p if p.name == name
      break if provider

    if !provider?
      return callback(new Error('torrent not available through supported provider'), null)

    PROVIDERS[provider.name](provider.url, callback)

module.exports.search = search
module.exports.getProviders = getProviders
module.exports.getMagnetLink = getMagnetLink
