require 'stdlibjs/Object.assign'

jQuery = require('jquery')

request = (method, url, params, options={}) ->

  options = Object.assign({}, options, {
    method: method
    url: url
    data: params
  })

  new Promise (resolve, reject) ->
    ChromeExtension.request options, (response, request) ->
      if response.status < 400
        resolve(response.responseJSON || response.responseText)
      else
        console.warn('Request failed', options, response, request)
        reject(response)
    # request = jQuery.ajax(options)

    # request.done (result) ->
    #   resolve(result)

    # request.error (xhr, textStatus, errorThrown) ->
    #   if xhr?.state?() == 'rejected'
    #     warnAboutChromeExtension()
    #     retry()
    #   else
    #     console.warn('Request failed', options, xhr, textStatus, errorThrown)
    #     error = new Error('Request failed: '+textStatus+' / '+errorThrown)
    #     error.xhr = xhr
    #     reject(error)


request.get = (path, params) ->
  request('get', path, params)

request.post = (path, params) ->
  request('post', path, params)


module.exports = request

warnAboutChromeExtension = ->
  console.warn("""
    ~~~~~ WARNING ~~~~~

    It's possible the Torflix chrome extensions is not installed

    Get it here #{location.origin}/Torflix-chrome-extension.crx

    ~~~~~ WARNING ~~~~~
  """)
