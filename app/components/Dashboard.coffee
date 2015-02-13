React             = require 'react'
component         = require '../component'
TransfersList     = require './TransfersList'
DashboardControls = require './DashboardControls'
AddTorrentForm    = require './AddTorrentForm'
FilesTab          = require './FilesTab'
Videos            = require './Videos'
VideoPlayerModal  = require './VideoPlayerModal'
TabbedArea        = require 'react-bootstrap/TabbedArea'
TabPane           = require 'react-bootstrap/TabPane'

{div, h1, a} = React.DOM


PromptMixin =

  childContextTypes:
    setPrompt: React.PropTypes.func.isRequired
    clearPrompt: React.PropTypes.func.isRequired

  getChildContext: ->
    setPrompt: @setPrompt
    clearPrompt: @clearPrompt

  setPrompt: (prompt) ->
    @setState prompt: prompt

  clearPrompt: (prompt) ->
    @setState prompt: null

  renderPrompt: ->
    @state.prompt() if @state.prompt?


module.exports = component 'Dashboard',

  mixins: [PromptMixin]

  getInitialState: ->
    prompt: null

  contextTypes:
    path: React.PropTypes.object.isRequired

  render: ->
    div
      className: 'Dashboard',

      DashboardControls()

      AddTorrentForm(),

      TabbedArea
        defaultActiveKey: 1
        TabPane
          eventKey: 1
          tab: 'Transfers'
          TransfersList()

        TabPane
          eventKey: 2
          tab: 'Files'
          FilesTab()

        TabPane
          eventKey: 3
          tab: 'Videos'
          Videos()


      @VideoPlayerModal()
      @renderPrompt()


  VideoPlayerModal: ->
    params = @context.path.params()
    return unless params.v
    VideoPlayerModal fileId: params.v, onClose: @closeVideoPlayerModal

  closeVideoPlayerModal: ->
    @context.path.set @context.path.where(v: undefined)


