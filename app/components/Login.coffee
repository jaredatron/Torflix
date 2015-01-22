React     = require 'react'
component = require '../component'

{div, h1, a} = React.DOM


module.exports = component 'Login',
  render: ->
    div(null,
      h1(null, 'Welcome to the put.io app.')
      LoginButton()
    )



LoginButton = component 'LoginButton',
  render: ->
    client_id = process.env.PUT_IO_CLIENT_ID
    redirect_uri = encodeURIComponent(process.env.PUT_IO_REDIRECT_URI)
    a(
      href: "https://api.put.io/v2/oauth2/authenticate?client_id=#{client_id}&response_type=token&redirect_uri=#{redirect_uri}",
      'Click here to sign in :O'
    )
