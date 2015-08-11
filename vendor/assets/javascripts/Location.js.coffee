#= require 'eventemitter3'
#= require 'Object.assign'

location = @location

@Location = class Location
  constructor: ->
    window.addEventListener 'popstate', @update.bind(this)
    @update()

Object.assign(Location.prototype, EventEmitter.prototype)

Location.prototype.update = ->
  @path   = location.pathname
  @params = searchToObject(location.search)
  @emit('change')

Location.prototype.for = (path=@path, params=@params) ->
  path ||= ''
  path = '/'+path if path[0] != '/'
  "#{path}#{objectToSearch(params)}"


Location.prototype.set = (value, replace) ->
  value = "/#{value}" unless value[0] == '/'
  if replace
    history.replaceState({}, document.title, value)
  else
    history.pushState({}, document.title, value)
  @update()

Location.prototype.setPath = (path, replace) ->
  @set(@for(path), replace)

Location.prototype.setParams = (params, replace) ->
  @set(@for(null, params), replace)

Location.prototype.updateParams = (params, replace) ->
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


