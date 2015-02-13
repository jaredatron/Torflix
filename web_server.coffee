require './env'
NODE_ENV = process.env.NODE_ENV || 'development'

http        = require 'http'
fs          = require 'fs'
express     = require 'express'
cheerio     = require 'cheerio'
Request     = require 'request'
querystring = require('querystring')

web = express()
web.set 'title', 'putio'
web.set 'port', (process.env.PORT || 5000)

require('./torrentz_routes')(web)

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
