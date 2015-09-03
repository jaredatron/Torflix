require 'stdlibjs/Object.assign'

jQuery = require('jquery')

request = (method, url, params, options={}) ->

  options = Object.assign({}, options, {
    method: method
    url: url
    data: params
  })

  r = jQuery.ajax(options)

  new Promise (resolve, reject) ->
    r.done (result) ->
      resolve(result)
    r.error (xhr, textStatus, errorThrown) ->
      detectAccessControlAllowOriginError(xhr)
      console.warn('Request failed', options, xhr, textStatus, errorThrown)
      error = new Error('Request failed: '+textStatus+' / '+errorThrown)
      error.xhr = xhr
      reject(error)


request.get = (path, params) ->
  request('get', path, params)

request.post = (path, params) ->
  request('post', path, params)


detectAccessControlAllowOriginError = (xhr) ->
  if xhr?.state?() == 'rejected'
    console.warn("""
      ~~~~~ WARNING ~~~~~

      It's possible the Torflix chrome extensions is not installed

      Get it here #{location.origin}/Torflix-chrome-extension.crx

      ~~~~~ WARNING ~~~~~
    """)



module.exports = request
