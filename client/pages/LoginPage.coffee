component = require 'reactatron/component'
Layer = require 'reactatron/Layer'
Rows = require 'reactatron/Rows'
Block = require 'reactatron/Block'
LoginButton = require '../components/LoginButton'

module.exports = component 'LoginPage',

  addPutioAccessToken: ->
    @app.logout()

  render: ->

    Layer {},
      Rows {},
        Block {}, 'LoginPage'
        LoginButton {}
