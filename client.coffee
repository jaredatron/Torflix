require 'shouldhave/Object.assign'
require 'shouldhave/Array#find'
require './client/debug'

app = require './client/app'

require('domready') ->
  app.start()
