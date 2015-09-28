WEBKIT_THINGS = [
  'boxSizing'
  'alignItems'
  'alignContent'
  'flexDirection'
  'flexWrap'
  'flexGrow'
  'flexShrink'
  'justifyContent'
]
Style = require('reactatron/Style')
Style.prototype._compute = Style.prototype.compute
Style.prototype.compute = (state) ->
  style = @_compute(this, state)
  for key, value of style
    switch
      when key == 'display' && value == 'flex'
        style.display = '-webkit-flex'
      when key == 'display' && value == 'inline-flex'
        style.display = '-webkit-inline-flex'

      when WEBKIT_THINGS.includes(key)
        webkitKey = 'Webkit'+key[0].toUpperCase()+key.slice(1)
        style[webkitKey] ||= style[key]

  style




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



