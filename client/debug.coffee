window.DEBUG = DEBUG = {};

DEBUG.log = console.log.bind(console)
DEBUG.React = require 'react'
App = require './App'
DEBUG.App = App

DEBUG.App.sub /.*/, (event) ->
  console.log('Event', event)

DEBUG.App.sub 'store:change:location', ->
  console.info('Location change', App.get('location'))


DEBUG.App.pub('DEBUG:here')
