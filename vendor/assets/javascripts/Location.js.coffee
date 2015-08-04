#= require 'eventemitter3'
#= require 'Object.assign'

location = @location

Location = @Location = {
  path:   '/',
  params: {},
}

Object.assign(Location, EventEmitter.prototype)

Location.for = (path=@path, params=@params) ->
  path ||= ''
  path = '/'+path if path[0] != '/'
  "#{path}#{objectToSearch(params)}"


Location.set = (value, replace) ->
  value = "/#{value}" unless value[0] == '/'
  if replace
    history.replaceState({}, document.title, value)
  else
    history.pushState({}, document.title, value)
  update()
  Location

Location.setPath = (path, replace) ->
  @set(@for(path), replace)

Location.setParams = (params, replace) ->
  @set(@for(null, params), replace)

Location.updateParams = (params, replace) ->
  @setParams(Object.assign({}, @params, params), replace)


# private

update = ->
  Location.path   = location.pathname
  Location.params = searchToObject(location.search)
  Location.emit('change')


searchToObject = (search) ->
  params = {}
  search = search.substring(search.indexOf('?') + 1, search.length);
  return {} if search.length == 0
  search.split(/&+/).forEach (param) ->
    [key, value] = param.split('=')
    key = decodeURIComponent(key)
    if value?
      value = decodeURIComponent(value)
    else
      value = true
    params[key] = value
  params


objectToQueryString = (params) ->
  return undefined if !params?
  pairs = []
  Object.keys(params).forEach (key) ->
    value = params[key]
    switch value
      when true
        pairs.push "#{encodeURIComponent(key)}"
      when false, null, undefined
      else
        pairs.push "#{encodeURIComponent(key)}=#{encodeURIComponent(value)}"
  pairs.join('&')

objectToSearch = (params) ->
  search = objectToQueryString(params)
  if search.length == 0 then '' else '?'+search


window.addEventListener 'popstate', update

update()
