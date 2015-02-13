torrentz = require('./torrentz')

module.exports = (web) ->

  web.get '/search', (request, response) ->
    response.setHeader('content-type', 'application/json')

    torrentz.search request.query.q, (error, results) ->
      if error
        response.status(500).send error: error.message
      else
        response.status(200).send JSON.stringify({
          length: results.length,
          results: results,
        })

  web.get '/magnet/:id', (request, response) ->
    response.send ''
