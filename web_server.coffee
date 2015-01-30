require './env'
NODE_ENV = process.env.NODE_ENV || 'development'

fs         = require 'fs'
express    = require 'express'

web = express()
web.set 'title', 'putio'
web.set 'port', (process.env.PORT || 5000)

if NODE_ENV == 'development'
  require('node-pow')(web)
  require('./asset_routes')(web)

web.use express.static(__dirname + '/public')

if NODE_ENV != 'development'
  web.get '*', (request, response) ->
    fs.createReadStream('./public/app.html').pipe(response)


web.listen web.get('port'), ->
  console.log("Node app is running at http://localhost:" + web.get('port'))
