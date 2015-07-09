# location = @location

# PageState = @PageState = {
#   path:   '/',
#   params: {},
# }

# Object.assign(session, EventEmitter.prototype)

# PageState.set = (value, replace) ->

# PageState.set = (value, replace) ->
#   value = "/#{value}" unless value[0] == '/'
#   if replace
#     history.replaceState({}, document.title, value)
#   else
#     history.pushState({}, document.title, value)
#   this

# PageState.setPath = (value, replace) ->


# update = ->
#   PageState.path   = location.pathname
#   PageState.params = parseParams()
#   PageState.emit('change')


# PARAMS_REGEXP = /([^&=]+)=?([^&]*)/g
# parseParams = ->
#   params = {}
#   search = location.search
#   search = search.substring(search.indexOf('?') + 1, search.length);
#   search.split(/&+/).forEach (param) ->
#     [key, value] = param.split('=')
#     key = decodeURIComponent(key)
#     value = decodeURIComponent(value) if value?
#     params[key] = value
#   params


# window.addEventListener 'popstate', update
# update()