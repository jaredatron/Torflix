require('./FontAwesome').load()

ReactatronApp = require('reactatron/App')

app = new ReactatronApp
  responsiveWidths: [480, 768, 992, 1200]

require('./router')(app)
require('./authentication')(app)
require('./actions/putio')(app)
require('./actions/transfers')(app)
require('./actions/files')(app)

module.exports = app
