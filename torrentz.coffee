cheerio     = require 'cheerio'
Request     = require 'request'
querystring = require 'querystring'

module.exports.search = (query, callback) ->
  url = "http://torrentz.eu/search?#{querystring.stringify(q: query)}"
  options = {url: url, headers: {'user-agent': 'Mozilla/5.0'}}

  Request options, (error, response, body) ->
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
