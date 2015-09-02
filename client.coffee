require 'stdlibjs/Object.assign'
require 'stdlibjs/Array#find'
require './client/debug'

app = require './client/app'

require('domready') ->
  app.start()
