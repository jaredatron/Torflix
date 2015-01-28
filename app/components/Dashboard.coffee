React         = require 'react'
component     = require '../component'
TransfersList = require './TransfersList'
NewTransfer   = require './NewTransfer'
FileList      = require './FileList'
Button        = require 'react-bootstrap/Button'
Modal         = require 'react-bootstrap/Modal'
ModalTrigger  = require 'react-bootstrap/ModalTrigger'

{div, h1, a} = React.DOM


module.exports = component 'Dashboard',

  contextTypes:
    path: React.PropTypes.object.isRequired

  render: ->
    div(
      className: 'Dashboard',
      Navbar()
      NewTransfer(),
      TransfersList(),
      FileList(file_id: 0),
      @VideoPlayerModal()
    )

  VideoPlayerModal: ->
    params = @context.path.params()
    return unless params.v
    VideoPlayerModal
      file_id: params.v,
      onRequestHide: @hideVideoPlauerModal

  hideVideoPlauerModal: ->
    @context.path.set @context.path.where(v: undefined)

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



VideoPlayerModal = component 'VideoPlayerModal',
  render: ->
    Modal(title: "Video Player Modal", animation: true, backdrop: true,
      div( className: "modal-body",
        div(null, 'This is the modal')
      )
      div( className: "modal-footer",
        Button(onClick: @props.onRequestHide, 'Close')
      )
    )

