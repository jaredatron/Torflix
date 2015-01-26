React      = require 'react'
component  = require '../component'
ActionLink = require './ActionLink'
Glyphicon  = require 'react-bootstrap/Glyphicon'

{a, div, table, thead, tbody, tr, td, th} = React.DOM


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
    # .catch (error) =>
    #   @setState error: error

  componentWillUnmount: ->
    @context.putio.transfers.off('change', @transfersChanged)

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


  render: ->
    div className: 'transfers',
      div className: 'transfers-header',
        div className: 'delete',     ''
        div className: 'status',     'Status'
        div className: 'name',       'Name'
        div className: 'created_at', 'Created At'
      @props.transfers.map (transfer) =>
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


  toggleFilesLink: ->
    icon = if @state.showingFiles
      Glyphicon(glyph:'chevron-down')
    else
      Glyphicon(glyph:'chevron-right')

    ActionLink(onClick: @toggleFiles, icon)

  deleteLink: ->
    ActionLink(onClick: @delete, 'X')

  renderFiles: ->
    return null unless @state.showingFiles
    File file_id: @props.file_id

  render: ->
    div className: 'transfer',
      div key: @props.id, className: 'transfer-row',
        div className: 'toggle-files', @toggleFilesLink()
        div className: 'status',       @props.status
        div className: 'name',         @props.name
        div className: 'created_at',   @props.created_at
        div className: 'delete',       @deleteLink()
      @renderFiles()







File = component 'TransferListFile',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  propTypes:
    file_id: React.PropTypes.number.isRequired

  getInitialState: ->
    file:  @props.file
    files: @props.files

  isLoading: ->
    !@state.file?

  isDirectory: ->
    @state.file.content_type == "application/x-directory"

  loadFile: ->
    if !@state.file?
      @context.putio.files.get(@props.file_id).then (file) =>
        @setState file: file
        @loadFiles() if @isDirectory()
        file
    else if @isDirectory() && !@state.files?
      # @loadFiles()
      null

  loadFiles: ->
    @context.putio.transfers.list(@props.file_id).then (files) =>
      @setState files: files
      files

  componentDidMount: ->
    @loadFile()

  render: ->
    console.log('RENDERING', @props, @state)
    div className: 'transfer-list-file', @renderContent()

  renderContent: ->
    if @state.files?
      @state.files.map (file) ->
        File
          key:     file.id
          file_id: file.id
          file:    file

    else if @state.file?
      div(null,
        if @isDirectory()
          div(null, "DIR: #{@state.file.name}")
        else
          div(null, "FILE: #{@state.file.name}")
      )

    else
      div null, "loading…"
