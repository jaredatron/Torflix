React     = require 'react'
component = require './component'

{div, span, a, h1} = require('react').DOM


module.exports = component 'App',

  getInitialState: ->
    put_io_access_token: null

  componentDidMount: ->
    if matches = location.hash.match(/^#access_token=(.*)$/)
      location.hash = ''
      @setState put_io_access_token: matches[1]

  render: ->
    if @state.put_io_access_token
      div(null, "You're logged in with access token #{@state.put_io_access_token}")
    else
      div(null,
        h1(null, 'Welcome to the put.io app.')
        AuthenticateButton()
      )



AuthenticateButton = component 'AuthenticateButton',
  render: ->
    client_id = process.env.PUT_IO_CLIENT_ID
    redirect_uri = encodeURIComponent(process.env.PUT_IO_REDIRECT_URI)
    a(
      href: "https://api.put.io/v2/oauth2/authenticate?client_id=#{client_id}&response_type=token&redirect_uri=#{redirect_uri}",
      'Click here to sign in :O'
    )
