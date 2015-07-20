App.request = (method, url, params) ->
  request = $.ajax
    method: method
    url: url
    data: params
    dataType: 'json'

  new Promise (resolve, reject) ->
    request.done (result) ->
      resolve(result)
    request.error (xhr, textStatus, errorThrown) ->
      error = new Error('Putio request failed: '+textStatus+' / '+errorThrown)
      error.xhr = xhr
      reject(error)
