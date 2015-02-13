qwest = require('qwest')
querystring = require 'querystring'

search = (query, callback) ->
  qwest.get('/torrentz/search', {q: query}, {responseType: 'json'}).then (response) ->
    response.results

getProviders = (id, callback) ->
  debugger

getMagnetLink = (id, callback) ->
  qwest.get("/torrentz/magnet-link/#{id}", {}, {responseType: 'json'}).then (response) ->
    response.magnetLink

module.exports.search = search
module.exports.getProviders = getProviders
module.exports.getMagnetLink = getMagnetLink
