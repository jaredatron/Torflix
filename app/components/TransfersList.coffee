React      = require 'react'
component  = require '../component'
ActionLink = require './ActionLink'
FileList   = require './FileList'
Glyphicon  = require 'react-bootstrap/Glyphicon'

{div, span, a} = React.DOM


module.exports = component 'TransfersList',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  getInitialState: ->
    error: null
    transfers: @context.putio.transfers.toArray()

  transfersChanged: ->
    console.log('transfersChanged')
    setTimeout =>
      @setState transfers: @context.putio.transfers.toArray()

  componentDidMount: ->
    @context.putio.transfers.on('change', @transfersChanged)
    @context.putio.transfers.startPolling()

  componentWillUnmount: ->
    @context.putio.transfers.off('change', @transfersChanged)
    @context.putio.transfers.stopPolling()

  render: ->
    div
      className: 'TransfersList'
      @renderContent()

  renderContent: ->
    switch
      when @state.error
        div(null, "ERROR: #{@state.error}")
      when @state.transfers
        Table(transfers: @state.transfers, deleteTranfer: @deleteTranfer)
      else
        div(null, 'Loading…')


Table = component 'TransfersListTable',
  transfers: ->
    @props.transfers.sort (a, b) ->
      a = Date.parse(a.created_at)
      b = Date.parse(b.created_at)
      return -1 if a > b
      return  1 if a < b
      return  0 if a == b
  render: ->
    div className: 'transfers',
      div className: 'transfers-header',
        div className: 'delete',     ''
        div className: 'status',     'Status'
        div className: 'name',       'Name'
        div className: 'created_at', 'Created At'
        div className: 'delete',     ''
      @transfers().map (transfer) =>
        TransferRow
          key:        transfer.id
          id:         transfer.id
          status:     transfer.status
          name:       transfer.name
          created_at: transfer.created_at
          file_id:    transfer.file_id
          delete:     @props.deleteTranfer



TransferRow = component 'TransferRow',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  getInitialState: ->
    showingFiles: false

  toggleFiles: ->
    @setState showingFiles: !@state.showingFiles


  delete: (event) ->
    event.preventDefault()
    console.log("PRETENDING TO DELETE TRANSFER #{@props.id}")
    # @context.putio.transfers.delete(@props.id).catch (error) =>
    #   @setState error: error

  toggleFilesActionLink: (children...) ->
    ActionLink(onClick: @toggleFiles, children...)

  stateIcon: ->
    if @state.showingFiles
      Glyphicon(glyph:'chevron-down')
    else
      Glyphicon(glyph:'chevron-right')

  deleteLink: ->
    ActionLink(onClick: @delete, 'X')

  renderFiles: ->
    return null unless @state.showingFiles
    FileList file_id: @props.file_id

  render: ->
    div className: 'transfer',
      div key: @props.id, className: 'transfer-row',
        div className: 'toggle-files', @toggleFilesActionLink @stateIcon()
        div className: 'status',       @toggleFilesActionLink @props.status
        div className: 'name',         @toggleFilesActionLink @props.name
        div className: 'created_at',   @toggleFilesActionLink @props.created_at
        div className: 'delete',       @deleteLink()
      @renderFiles()

