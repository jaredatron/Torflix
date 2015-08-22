$ = require('jquery')

module.exports = (method, url, params, options={}) ->

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
      console.warn('Request failed', options, xhr, textStatus, errorThrown)
      error = new Error('Request failed: '+textStatus+' / '+errorThrown)
      error.xhr = xhr
      reject(error)
