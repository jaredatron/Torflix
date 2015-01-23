React         = require 'react'
component     = require '../component'
TransfersList = require './TransfersList'
NewTransfer   = require './NewTransfer'
Button        = require 'react-bootstrap/Button'

{div, h1, a} = React.DOM


module.exports = component 'Dashboard',
  render: ->
    div(
      className: 'Dashboard',
      h1(null, "You're logged in"),
      LogoutButton(),
      NewTransfer(),
      TransfersList(),
      Button(bsStyle:"primary", 'Primary')
    )





LogoutButton = component 'LogoutButton',
  logout: (event) ->
    event.preventDefault()
    session('put_io_access_token', null)
  render: ->
    a(href:'', onClick: @logout, 'Logout')

