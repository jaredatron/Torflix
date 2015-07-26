#= require Request

App.request = (method, url, params) ->
  Request(method, url, params, {
    dataType: 'json'
  })

App.get = (url, params) ->
  App.request('GET', url, params)

App.post = (url, params) ->
  App.request('POST', url, params)
