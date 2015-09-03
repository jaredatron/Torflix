require('./FontAwesome').load()

App = require('reactatron/App')
component = require('reactatron/component')

app = new App
  responsiveWidths: [480, 768, 992, 1200]
  render: require('./components/AppRoot')
  pages:
    Login:     require('./pages/LoginPage')
    Transfers: require('./pages/TransfersPage')
    Files:     require('./pages/FilesPage')
    Video:     require('./pages/VideoPage')
    Search:    require('./pages/SearchPage')
    Shows:     require('./pages/ShowsPage')
    NotFound:  require('./pages/NotFoundPage')


require('./router')(app)
require('./authentication')(app)
require('./actions/putio')(app)
require('./actions/transfers')(app)
require('./actions/files')(app)
require('./actions/search')(app)

module.exports = app



