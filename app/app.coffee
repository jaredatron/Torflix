React     = require 'react'
component = require './component'

{div, span, a} = require('react').DOM

module.exports = component 'App',

  render: ->
    div(null,
      AuthenticateButton()
    )



AuthenticateButton = component 'AuthenticateButton',
  render: ->
    client_id = process.env.PUT_IO_CLIENT_ID
    redirect_uri = encodeURIComponent(process.env.PUT_IO_REDIRECT_URI)
    a(
      href: "https://api.put.io/v2/oauth2/authenticate?client_id=#{client_id}&response_type=code&redirect_uri=#{redirect_uri}",
      'Click here to sign in'
    )
