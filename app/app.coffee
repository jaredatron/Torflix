component = require './component'
qwest     = require 'qwest'
session   = require './session'


global.qwest = qwest

{div, span, a, h1} = require('react').DOM


getState = ->
  put_io_access_token: session('put_io_access_token')

module.exports = component 'App',

  getInitialState: ->
    getState()

  onChange: ->
    @setState getState()

  componentDidMount: ->
    session.on('change', @onChange)
    if put_io_access_token = getTokenFromHash()
      session('put_io_access_token', put_io_access_token)

  componentWillUnmount: ->
    session.off('change', @onChange)

  render: ->
    if @state.put_io_access_token
      div(null,
        h1(null, "You're logged in with access token #{@state.put_io_access_token}"),
        LogoutButton()
      )
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

LogoutButton = component 'LogoutButton',
  logout: (event) ->
    event.preventDefault()
    session('put_io_access_token', null)
  render: ->
    a(href:'', onClick: @logout, 'Logout')


getTokenFromHash = ->
  if matches = location.hash.match(/^#access_token=(.*)$/)
    location.hash = ''
    matches[1]
