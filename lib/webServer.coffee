require '../environment'

fs         = require('fs')
express    = require('express')
app        = express()
publicDir  = process.env.ROOT_PATH + '/public'

module.exports = ->

  if 'development' == process.env.NODE_ENV
    httpProxy = require('http-proxy')
    proxy = httpProxy.createProxyServer()
    webAssetsServer = require('./webAssetsServer')
    webAssetsServer.start()
    app.get '/assets/*', (req, res) ->
      proxy.web req, res, target: 'http://localhost:' + webAssetsServer.port
      return

  app.set 'port', process.env.PORT or 3000

  app.use express.static(publicDir)

  app.get '/*', (request, response) ->
    response.sendFile publicDir + '/index.html'
    return

  app.start = (callback) ->
    app.listen app.get('port'), callback

  return app
