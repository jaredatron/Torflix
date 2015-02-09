assets = require('./assets')

module.exports = (web) ->

  web.get "/app.js", (req, res) ->
    res.setHeader('content-type', 'application/javascript')
    assets.compile_javascript 'client', (error, javascript) ->
      if error
        res.send("document.write(#{errorToString(error, 'JS ERROR: ')})")
      else
        res.send(javascript)


  web.get "/app.css", (req, res) ->
    res.setHeader('content-type', 'text/css')
    assets.compile_stylesheet 'app', (error, css) ->
      if error
        res.send """
          body > * { display: none; }
          body:before {
            display: block !important;
            content: #{errorToString(error, 'CSS ERROR: ')};
          }
        """
      else
        res.send(css)


  web.get '*', (request, response) ->
    assets.compile_html (error, html) ->
      throw error if error
      response.send(html)


errorToString = (error, prefix) ->
  prefix ||= 'SERVER ERROR: '
  JSON.stringify("#{prefix}#{error.message}")

