#= require 'eventemitter3'
#= require 'Location'
#= require 'Object.assign'

routes = []

Route = @Route = Object.create(EventEmitter.prototype)

Route.match = (expression, component) ->
  routes.push new Route(expression, component)

Route.update = () ->
  {path, params} = Location
  for route in routes
    if allParams = route.match(path, params)
      Route.path   = path
      Route.params = allParams
      Route.emit('change')
  throw new Error('route not found for', path, params)


Location.on 'change', ->
  Route.update


# private

class Matcher
  constructor: (expression, params) ->
    @expression = expression
    @params     = params
    parseExpression.call(this, expression)

  match: (path, params) ->
    parts = path.match(@regexp)
    return false unless parts
    parts.shift()
    params = Object.assign({}, params, @params)
    @paramNames.forEach (paramName) ->
      params[paramName] = parts.shift()
    return params


escapeRegExp  = /[\-{}\[\]+?.,\\\^$|#\s]/g
namedParams   = /\/(:|\*)([^\/?]+)/g
parseExpression = (expression) ->
  paramNames = []
  expression = expression.replace(escapeRegExp, '\\$&')
  expression = expression.replace namedParams, (_, type, paramName) ->
    paramNames.push(paramName)
    switch type
      when ':' then '/([^/?]+)'
      when '*' then '/(.*?)'

  @paramNames = paramNames
  @regexp = new RegExp("^#{expression}$")
