assets = require('./assets')


module.exports = (web) ->
  web.get "/app.js", (req, res) ->
    res.setHeader('content-type', 'application/javascript')
    assets.javascript 'client', (error, asset) ->
      throw error if error
      asset.pipe(res)

  web.get "/app.css", (req, res) ->
    res.setHeader('content-type', 'text/css')
    assets.stylesheet 'app', (error, css) ->
      throw error if error
      res.send(css)
