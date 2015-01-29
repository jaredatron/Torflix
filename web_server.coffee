path       = require 'path'
express    = require 'express'
react      = require 'react'
browserify = require 'connect-browserify'
env        = require './env'

web = express()
web.set 'title', 'putio'
web.set 'port', (process.env.PORT || 5000)

if 'development' == web.get('env')
  require('node-pow')(web)
  require('./asset_routes')(web)


web.use express.static(__dirname + '/public')





web.get '*', (request, response) ->
  D = react.DOM
  html = react.renderToStaticMarkup(
    D.html(null,
      D.head(null,
        D.title(null, 'put.io')
        D.link(rel: 'stylesheet', href: 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css', type: 'text/css')
        D.link(rel: 'stylesheet', href: 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css', type: 'text/css')
        D.link(rel: 'stylesheet', href: '/app.css', type: 'text/css')
      )
      D.body(null,
        D.script(type: 'text/javascript', src: '//put.io/web/jwplayer/jwplayer.js')
        D.script(type: 'text/javascript', src: '/app.js')
      )
    )
  )

  response.send(html)


web.listen web.get('port'), ->
  console.log("Node app is running at http://localhost:" + web.get('port'))
