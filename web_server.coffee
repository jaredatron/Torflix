path       = require 'path'
express    = require 'express'
react      = require 'react'
browserify = require 'connect-browserify'

# load .env file
require('node-env-file')(__dirname + '/.env');

web = express()
web.set 'title', 'putio'
web.set 'port', (process.env.PORT || 5000)

web.use express.static(__dirname + '/public')

# web.get "client.js", browserify(
#   entry: path.join(__dirname, "app/client")
#   debug: true
#   watch: true
#   transforms: ['coffeeify', 'envify']
#   extensions: [".cjsx", ".coffee", ".js", ".json"]
# )

web.get '*', (request, response) ->
  D = react.DOM
  html = react.renderToStaticMarkup(
    D.html(null,
      D.head(null,
        D.title(null, 'Progwiki')
        D.link(rel: 'stylesheet', href: 'app.css', type: 'text/css')
      )
      D.body(null,
        D.script(src: 'client.js')
      )
    )
  )

  response.send(html)

if 'development' == web.get('env')
  require('node-pow')(web)

web.listen web.get('port'), ->
  console.log("Node app is running at http://localhost:" + web.get('port'))
