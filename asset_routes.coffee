assets = require('./assets')

module.exports = (web) ->

  web.get "/app.js", (req, res) ->
    res.setHeader('content-type', 'application/javascript')
    assets.compile_javascript 'client', (error, asset) ->
      if error
        sendError(res, error)
      else
        asset.on 'error', (error) ->
          sendError(res, error)
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


sendError = (res, error) ->
  errorMessage = JSON.stringify("SERVER ERROR: #{error.message}")
  res.send("alert(#{errorMessage})")
