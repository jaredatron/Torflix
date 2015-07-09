#
# Usage:
#
# router = new Router ->
#   @match '/',      @redirectTo('/shows')
#   @match '/shows', DOM.ShowsPage
#

class Router
  constructor: (spec) ->
    @routes = []
    spec.call(this)

  match: (expression, component) ->
    @routes.push new Route(expression, component)

  pageFor: (path, params) ->
    for route in @routes
      if allParams = route.match(path, params)
        return allParams

@Router = Router


# private

class Route
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
