# #
# # Usage:
# #
# # router = new Router ->
# #   @match '/',      @redirectTo('/shows')
# #   @match '/shows', DOM.ShowsPage
# #

# class Router
#   constructor: (spec) ->
#     @routes = []
#     spec.call(this)

#   match: (expression, component) ->
#     @routes.push new Route(expression, component)

#   pageFor: (path, params) ->
#     for route in @routes
#       if allParams = route.match(path, params)
#         return allParams

# class Route
#   constructor: (expression, component) ->
#     @expression = expression
#     @component  = component
#     parseExpression.call(this, expression)

#   match: (path, params) ->
#     parts = path.match(@regexp)
#     return false unless parts
#     parts.shift()
#     params = Object.assign({}, params)
#     @params.forEach (param) ->
#       params[param] = parts.shift()
#     return params

# @Router = Router

# # @Route = class
# #   constructor: (expression) ->
# #     return new Route(expression) unless this instanceof Route
# #     @expression = expression
# #     parseExpression.call(this, expression)

# #   match: (path) ->
# #     parts = path.match(@regexp)
# #     return false unless parts
# #     parts.shift()
# #     params = {}
# #     @params.forEach (param) ->
# #       params[param] = parts.shift()
# #     return params


# escapeRegExp  = /[\-{}\[\]+?.,\\\^$|#\s]/g
# namedParams   = /\/(:|\*)([^\/?]+)/g
# parseExpression = (expression) ->
#   params = []
#   expression = expression.replace(escapeRegExp, '\\$&')
#   expression = expression.replace namedParams, (_, type, param) ->
#     params.push(param)
#     switch type
#       when ':' then '/([^/?]+)'
#       when '*' then '/(.*?)'

#   @params = params
#   @regexp = new RegExp("^#{expression}$")
