require './env'
NODE_ENV = process.env.NODE_ENV || 'development'

http = require 'http'
fs = require 'fs'
express = require 'express'

web = express()
web.set 'title', 'putio'
web.set 'port', (process.env.PORT || 5000)

web.get '/search', (request, response) ->
  # https://torrentz.eu/search?q=50+shades+of+grey
      # "http://torrentz.eu/search?q=50+shades+of+grey"
  options = {
    'host':       'torrentz.eu'
    'method':     'GET'
    'path':       '/search?q=50+shades+of+grey'
    'user-agent': 'Mozilla/5.0'
    # 'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36'
    'keepAlive':  false
  }
  req = http.get options, (res) ->
    res.pipe(response)
  #   console.log("Got response: ", res.statusCode)

  #   body = ''
  #   res.on 'data', (chunk) ->
  #     body += chunk

  #   res.on 'end', (chunk) ->
  #     response.send(body)

  # req.on 'error', (e) ->
  #   response.send JSON.stringify(error: e.message)




if NODE_ENV == 'development'
  require('node-pow')(web)
  require('./asset_routes')(web)
else
  require('./assets').precompile()

web.use express.static(__dirname + '/public')


if NODE_ENV != 'development'
  web.get '*', (request, response) ->
    fs.createReadStream('./public/app.html').pipe(response)


web.listen web.get('port'), ->
  console.log("Node app is running at http://localhost:" + web.get('port'))
