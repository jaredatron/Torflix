path       = require 'path'
express    = require 'express'
browserify = require 'connect-browserify'
env        = require './env'
fs         = require 'fs'

web = express()
web.set 'title', 'putio'
web.set 'port', (process.env.PORT || 5000)

if 'development' == web.get('env')
  require('node-pow')(web)
  require('./asset_routes')(web)

web.use express.static(__dirname + '/public')

if 'development' != web.get('env')
  web.get '*', (request, response) ->
    fs.createReadStream('./public/app.html').pipe(response)


web.listen web.get('port'), ->
  console.log("Node app is running at http://localhost:" + web.get('port'))
