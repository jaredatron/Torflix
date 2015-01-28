EventEmitter = require('events').EventEmitter
querystring  = require('querystring')
assign       = require('object-assign')

fromString = (string) ->
  querystring.parse(string)

toString = (params) ->
  params = assign({}, params)
  for key, value of params
    delete params[key] if typeof value == 'undefined'
  querystring.stringify(params)

toSearch = (params) ->
  search = toString(params)
  if search.length == 0 then '' else '?'+search

module.exports = (location, history) ->
  path = assign({}, EventEmitter.prototype)

  path.init = ->
    window.addEventListener 'popstate', (event) =>
      path.emit('change')

  path.toString = ->
    if location.search
      location.pathname+location.search
    else
      location.pathname

  path.pathname = (pathname, replace) ->
    if arguments.length == 0
      location.pathname
    else
      path.set(path.for(pathname, path.params()), replace)
      this

  path.search = (search, replace) ->
    if arguments.length == 0
      location.search.replace(/^\?/,'')
    else
      params = fromString(search)
      path.set(path.for(path.pathname(), params), replace)
      this

  path.params = (params, replace) ->
    if arguments.length == 0
      fromString(path.search())
    else
      path.set(path.for(path.pathname(), params), replace)
      this

  path.updateParams = (params, replace) ->
    params = path.params().merge(params)
    path.params(params, replace)

  path.set = (value, replace) ->
    value = "/#{value}" unless value[0] == '/'
    if replace
      history.replaceState({}, document.title, value)
    else
      history.pushState({}, document.title, value)
    path.emit('change')
    this

  # path.for('/campaigns', page: 3) #=> '/campaigns?page=3'
  path.for = (pathname, params) ->
    pathname ||= ''
    pathname = '/'+pathname if pathname[0] != '/'
    "#{pathname}#{toSearch(params)}"

  path.where = (pathname, params) ->
    if arguments.length == 1 && typeof pathname == 'object'
      params = pathname
      pathname = null
    pathname ||= path.pathname()
    params = assign({}, path.params(), params)
    path.for(pathname, params)

  path.removeHash = ->
    path.set(path.toString())


  return path
