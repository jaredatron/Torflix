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
    throw new Error('route not found for', path, params)

@Router = Router


