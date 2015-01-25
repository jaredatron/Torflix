React         = require 'react'
component     = require '../component'
TransfersList = require './TransfersList'
NewTransfer   = require './NewTransfer'
Button        = require 'react-bootstrap/Button'
Modal         = require 'react-bootstrap/Modal'
ModalTrigger  = require 'react-bootstrap/ModalTrigger'

{div, h1, a} = React.DOM


module.exports = component 'Dashboard',
  render: ->
    div(
      className: 'Dashboard',
      Navbar()
      NewTransfer(),
      TransfersList(),
      ModalTrigger
        modal: ExampleModal()
        Button(bsStyle:"primary", 'Primary')
    )


Navbar = component 'Navbar',
  render: ->
    div(
      className: 'Navbar',
      LogoutButton(),
    )


LogoutButton = component 'LogoutButton',
  logout: (event) ->
    event.preventDefault()
    session('put_io_access_token', null)
  render: ->
    a(href:'', onClick: @logout, 'Logout')



ExampleModal = component 'ExampleModal',
  render: ->
    Modal(title: "WOOOT BALLLZ", animation: true,
      div( className: "modal-body",
        div(null, 'This is the modal')
      )
      div( className: "modal-footer",
        Button(onClick: @props.onRequestHide, 'Close')
      )
    )

