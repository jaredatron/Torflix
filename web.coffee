path       = require 'path'
express    = require 'express'
react      = require 'react'
browserify = require 'connect-browserify'

# load .env file
require('node-env-file')(__dirname + '/.env');

web = express()
web.set 'port', (process.env.PORT || 5000)

web.use express.static(__dirname + '/public')

web.get "/js/bundle.js", browserify(
  entry: path.join(__dirname, "app/client")
  debug: true
  watch: true
  transforms: ['coffeeify', 'envify']
  extensions: [".cjsx", ".coffee", ".js", ".json"]
)


# web.get '/app.js', (req, res) ->
#   res.setHeader('content-type', 'application/javascript')
#   b = browserify(__dirname + '/app/client')
#   b._extensions.push('.coffee')
#   b = b.transform('coffeeify').bundle()
#   b.on('error', console.error)
#   b.pipe(res)


# https://deadlyicon-putio.herokuapp.com/callback
web.get '/callback', (req, res) ->

  # ?code=d734ce14a1d911e4a269001018321b64
  response.param('code')

  ###
  Request this:
  https://api.put.io/v2/oauth2/access_token
    ?client_id=YOUR_CLIENT_ID
    &client_secret=YOUR_CLIENT_SECRET
    &grant_type=authorization_code
    &redirect_uri=YOUR_REGISTERED_REDIRECT_URI
    &code=CODE
  ###

  response.send('CALLBACKED')

web.get '*', (request, response) ->
  D = react.DOM
  html = react.renderToStaticMarkup(
    D.html(null,
      D.head(null,
        D.title(null, 'Progwiki')
        D.script(null)
      )
      D.body(null,
        D.script(src: '/js/bundle.js')
      )
    )
  )

  response.send(html)

web.listen web.get('port'), ->
  console.log("Node app is running at http://localhost:" + web.get('port'))
