React     = require 'react'
component = require '../component'

{div, h1, a} = React.DOM


module.exports = component 'Dashboard',
  render: ->
    div(null,
      h1(null, "You're logged in"),
      LogoutButton()
    )





LogoutButton = component 'LogoutButton',
  logout: (event) ->
    event.preventDefault()
    session('put_io_access_token', null)
  render: ->
    a(href:'', onClick: @logout, 'Logout')

