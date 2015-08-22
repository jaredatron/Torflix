ReactatronApp = require('reactatron/App')
LocationPlugin = require('reactatron/LocationPlugin')
Putio = require('./Putio')

App = new ReactatronApp

App.registerPlugin LocationPlugin

# App.router.map ->
#   @match '/',               @redirectTo '/transfers'
#   @match '/shows',          -> require('./pages/ShowsPage')
#   @match '/shows/search',   -> require('./pages/ShowsSearchPage')
#   @match '/shows/:show_id', -> require('./pages/ShowPage')
#   @match '/transfers',      -> require('./pages/TransfersPage')
#   @match '/files',          -> require('./pages/FilesPage')
#   @match '/files/search',   -> require('./pages/FilesSearchPage')
#   @match '/search',         -> require('./pages/TorrentsSearchPage')
#   @match '/autoplay',       -> require('./pages/AutoplayPage')
#   @match '/video/:file_id', -> require('./pages/VideoPage')
#   @match '/*path',          -> require('./pages/PageNotFound')

# App.putio = new Putio(App.session.get('put_io_access_token'))

module.exports = App

