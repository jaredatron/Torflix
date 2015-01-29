React         = require 'react'
component     = require '../component'
TransfersList = require './TransfersList'
NewTransfer   = require './NewTransfer'
FileList      = require './FileList'
ActionLink    = require './ActionLink'
VideoPlayerModal = require './VideoPlayerModal'

Button     = require 'react-bootstrap/Button'
TabbedArea = require 'react-bootstrap/TabbedArea'
TabPane    = require 'react-bootstrap/TabPane'

{div, h1, a} = React.DOM


module.exports = component 'Dashboard',

  contextTypes:
    path: React.PropTypes.object.isRequired

  render: ->
    div
      className: 'Dashboard',

      Navbar()

      NewTransfer(),

      TabbedArea
        defaultActiveKey: 1
        TabPane
          eventKey: 1
          tab: 'Transfers'
          TransfersList()
        TabPane
          eventKey: 2
          tab: 'Files'
          FileList(file_id: 0)

      @VideoPlayerModal()


  VideoPlayerModal: ->
    params = @context.path.params()
    return unless params.v
    VideoPlayerModal fileId: params.v, onClose: @closeVideoPlayerModal

  closeVideoPlayerModal: ->
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
    ActionLink onClick: @logout, 'Logout'



