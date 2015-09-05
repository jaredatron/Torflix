require 'shouldhave/Object.assign'

ChromeExtension = require './ChromeExtension'

jQuery = require('jquery')

request = (method, url, params, options={}) ->

  options = Object.assign({}, options, {
    method: method
    url: url
    data: params
  })

  new Promise (resolve, reject) ->
    requestPromise = if requestIsCrossDomain(options)
      requestViaChromeExtension(options)
    else
      requestViaXMLHTTPRequest(options)

    requestPromise
      .then (response) ->
        if response.status < 400
          resolve(response.responseJSON || response.responseText)
        else
          console.warn('Request failed', options, response, request)
          reject(response)
      .catch(reject)


ALLOWED_DOMAINS = [
  location.host
  'https://put.io'
  'https://api.put.io'
]

requestIsCrossDomain = (options) ->
  url = options.url
  return true if url.indexOf('://') == -1 # relative path
  domain = options.url.match(/^[^\/]+:\/\/([^\/]+)/)[0]
  !ALLOWED_DOMAINS.includes(domain)

requestViaChromeExtension = (options) ->
  ChromeExtension.HTTPRequest(options)


requestViaXMLHTTPRequest = (options) ->
  new Promise (resolve, reject) ->
    jQuery.ajax(options).complete (response, textStatus) ->
      resolve
        request:      options
        status:       response.status
        textStatus:   textStatus
        responseText: response.responseText
        responseJSON: response.responseJSON

request.get = (path, params) ->
  request('get', path, params)

request.post = (path, params) ->
  request('post', path, params)


module.exports = request
