NODE_ENV = require './env'

console.log(NODE_ENV)

fs = require 'fs'
express = require 'express'

web = express()
web.set 'title', 'putio'
web.set 'port', (process.env.PORT || 5000)

web.use express.static(__dirname + '/public')

require('./torrentz_routes')(web)

web.get '/wtf', (request, response) ->
  response.send('wtf!?')



if NODE_ENV == 'development'
  require('./development_asset_routes')(web)
else
  web.get '*', (request, response) ->
    fs.createReadStream('./public/app.html').pipe(response)

web.listen web.get('port'), ->
  console.log("Node app is running at http://localhost:" + web.get('port'))


require('node-pow')(web) if true # NODE_ENV == 'development'
