component = require 'reactatron/component'
Link = require './Link'

module.exports = component 'LoginButton',
  render: ->
    Link
      href: @app.putio.generateLoginURI()
      'Login via put.io'
