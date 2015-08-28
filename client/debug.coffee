window.DEBUG = DEBUG = {};

DEBUG.log = console.log.bind(console)
DEBUG.React = require 'react/addons'
DEBUG.ReactElement = require 'react/lib/ReactElement'
app = require './app'
DEBUG.app = app
DEBUG.Style = require 'reactatron/Style'

# DEBUG.app.sub /.*/, (event, payload) ->
#   console.log('Event', event, payload)

# DEBUG.app.sub 'store:change:location', ->
#   console.info('Location change', app.get('location'))

app.sub 'store:change:horizontalSize', ->
  console.info('horizontalSize', app.get('horizontalSize'))

console.info('horizontalSize', app.get('horizontalSize'))


DEBUG.app.pub('DEBUG:here')


DEBUG.Block = require 'reactatron/Block'
DEBUG.Rows = require 'reactatron/Rows'
