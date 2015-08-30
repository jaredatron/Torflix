component = require 'reactatron/component'
Layer = require 'reactatron/Layer'
Rows = require 'reactatron/Rows'
Block = require 'reactatron/Block'
LoginButton = require '../components/LoginButton'

module.exports = component 'LoginPage',

  addPutioAccessToken: ->
    @app.set put_io_access_token: "LA0XFKMT"

  render: ->

    Layer {},
      Rows {},
        Block {}, 'LoginPage'
        LoginButton {}
