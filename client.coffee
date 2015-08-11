require 'stdlibjs/Object.assign'
require 'stdlibjs/Array/find'
require './client/debug'
App = require './client/App'

console.log 'App:', App


App.component 'Fucker',
  render: ->
    App.DOM.div(null, 'Fucker!')

require('domready') ->
  App.start()