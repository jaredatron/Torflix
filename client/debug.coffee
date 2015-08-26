window.DEBUG = DEBUG = {};

DEBUG.log = console.log.bind(console)
DEBUG.React = require 'react'
App = require './App'
DEBUG.App = App
DEBUG.Style = require 'reactatron/Style'

# DEBUG.App.sub /.*/, (event, payload) ->
#   console.log('Event', event, payload)

# DEBUG.App.sub 'store:change:location', ->
#   console.info('Location change', App.get('location'))

App.sub 'store:change:horizontalSize', ->
  console.info('horizontalSize', App.get('horizontalSize'))

console.info('horizontalSize', App.get('horizontalSize'))


DEBUG.App.pub('DEBUG:here')


DEBUG.Block = require 'reactatron/Block'
