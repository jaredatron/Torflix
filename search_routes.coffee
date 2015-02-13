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

  web.get '/providers/:id', (request, response) ->
    response.setHeader('content-type', 'application/json')

    torrentz.getProviders request.params.id, (error, results) ->
      if error
        response.status(500).send error: error.message
      else
        response.status(200).send JSON.stringify({
          length: results.length,
          results: results,
        })

  web.get '/magnet-link/:id', (request, response) ->
    response.setHeader('content-type', 'application/json')

    torrentz.getMagnetLink request.params.id, (error, magnetLink) ->
      if error
        response.status(500).send error: error.message
      else
        response.status(200).send JSON.stringify({
          magnetLink: magnetLink,
        })
