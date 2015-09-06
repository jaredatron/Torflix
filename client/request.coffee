require 'shouldhave/Object.assign'

jQuery = require('jquery')

request = (method, url, params, options={}) ->

  options = Object.assign({}, options, {
    method: method
    url: url
    data: params
  })

  new Promise (resolve, reject) ->
    jQuery.ajax(options).done(resolve).error(reject)

ALLOWED_DOMAINS = [
  location.host
  'https://put.io'
  'https://api.put.io'
]

request.get = (path, params) ->
  request('get', path, params)

request.post = (path, params) ->
  request('post', path, params)


module.exports = request
