require 'stdlibjs/Object.assign'
require 'stdlibjs/Array/find'
require './client/debug'

App = require './client/App'

require('domready') ->
  App.start()