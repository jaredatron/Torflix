@Request = (method, url, params, options={}) ->

  options = $.extend({}, options, {
    method: method
    url: url
    data: params
  })

  request = $.ajax(options)

  new Promise (resolve, reject) ->
    request.done (result) ->
      resolve(result)
    request.error (xhr, textStatus, errorThrown) ->
      detectAccessControlAllowOriginError(xhr)
      console.warn('Request failed', options, xhr, textStatus, errorThrown)
      error = new Error('Request failed: '+textStatus+' / '+errorThrown)
      error.xhr = xhr
      reject(error)

@Request.get = (url, params) ->
  Request('GET', url, params)

@Request.post = (url, params) ->
  Request('POST', url, params)



detectAccessControlAllowOriginError = (xhr) ->
  if xhr?.state?() == 'rejected'
    console.warn("""
      ~~~~~ WARNING ~~~~~

      It's possible the Torflix chrome extensions is not installed

      Get it here #{location.origin}/Torflix-chrome-extension.crx

      ~~~~~ WARNING ~~~~~
    """)
