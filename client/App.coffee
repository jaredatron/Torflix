ReactatronApp = require('reactatron/App')

App = new ReactatronApp

App.router.map ->
  @match '/',          require('./pages/HomePage')
  @match '/home',      @redirectTo('/')
  @match '/transfers', require('./pages/TransfersPage')
  @match '/*path',     require('./pages/NotFoundPage')

module.exports = App
