assets = require('./assets')

module.exports = (web) ->

  web.get "/app.js", (req, res) ->
    res.setHeader('content-type', 'application/javascript')
    assets.compile_javascript 'client', (error, javascript) ->
      if error
        res.send("alert(#{JSON.stringify(errorToString(error))})")
      else
        res.send(javascript)
        # asset.on 'error', (error) ->
        #   sendError(res, error)
        # asset.pipe(res)




  web.get "/app.css", (req, res) ->
    res.setHeader('content-type', 'text/css')
    assets.compile_stylesheet 'app', (error, css) ->
      if error
        throw error
      else
        res.send(css)


  web.get '*', (request, response) ->
    assets.compile_html (error, html) ->
      throw error if error
      response.send(html)


errorToString = (error) ->
  "SERVER ERROR: #{error.message}"

