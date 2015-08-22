component = require 'reactatron/component'
{div, button} = require 'reactatron/DOM'

module.exports = component 'LoginPage',

  addPutioAccessToken: ->
    @app.set 'put_io_access_token', "LA0XFKMT"

  render: ->
    div null,
      div null, 'LoginPage'
      button
        onClick: @addPutioAccessToken
        'Login'



