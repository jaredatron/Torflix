Router = require 'reactatron/Router'

module.exports = new Router ->
  @match '/',          @redirectTo('/transfers')
  @match '/transfers', require('./pages/TransfersPage')
  @match '/shows',     require('./pages/ShowsPage')
  @match '/*path',     require('./pages/NotFoundPage')
