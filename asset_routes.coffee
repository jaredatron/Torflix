assets = require('./assets')

module.exports = (web) ->

  web.get "/app.js", (req, res) ->
    res.setHeader('content-type', 'application/javascript')
    assets.compile_javascript 'client', (error, asset) ->
      throw error if error
      asset.pipe(res)

  web.get "/app.css", (req, res) ->
    res.setHeader('content-type', 'text/css')
    assets.compile_stylesheet 'app', (error, css) ->
      throw error if error
      res.send(css)


  web.get '*', (request, response) ->
    assets.compile_html (error, html) ->
      throw error if error
      response.send(html)
