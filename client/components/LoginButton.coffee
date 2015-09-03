component = require 'reactatron/component'
ButtonLink = require './ButtonLink'

module.exports = component 'LoginButton',
  render: ->
    ButtonLink
      href: @app.putio.generateLoginURI()
      'Login via put.io'
