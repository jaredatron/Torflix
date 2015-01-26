React      = require 'react'
component  = require '../component'
ActionLink = require './ActionLink'
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
    FileList file_id: @props.file_id

  render: ->
    div className: 'transfer',
      div key: @props.id, className: 'transfer-row',
        div className: 'toggle-files', @toggleFilesLink()
        div className: 'status',       @props.status
        div className: 'name',         @props.name
        div className: 'created_at',   @props.created_at
        div className: 'delete',       @deleteLink()
      @renderFiles()



FileList  = component 'TransferListTransferFile',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  propTypes:
    file_id: React.PropTypes.number.isRequired

  getInitialState: ->
    loading: true
    error: null

  componentDidMount: ->
    @context.putio.files.get(@props.file_id)
      .then((file) => @setState(file: file))
      .catch((message) => throw message)

  render: ->
    div className: 'FileList',
      if !@state.file?
        div(null, "loading…")
      else if isDirectory(@state.file)
        # DirectoryContents(directory_id: @props.file_id)
        Directory(directory: @state.file)
      else
        File(file: @state.file)






File = component 'TransferListFile',

  propTypes:
    file: React.PropTypes.object.isRequired

  render: ->
    div className: 'transfer-list-file',
      div className: 'transfer-list-file-name', @props.file.name

Directory = component 'TransferListDirectory',

  propTypes:
    directory: React.PropTypes.object.isRequired

  getInitialState: ->
    expanded: @props.expanded

  toggle: ->
    @setState expanded: !@state.expanded

  render: ->
    div className: 'transfer-list-directory',
      ActionLink onClick: @toggle,
        if @state.expanded
          Glyphicon(glyph:'chevron-down')
        else
          Glyphicon(glyph:'chevron-right')

      span className: 'transfer-list-directory-name', @props.directory.name

      if @state.expanded
        DirectoryContents(directory_id: @props.directory.id)


DirectoryContents = component 'TransferListFile',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  propTypes:
    directory_id: React.PropTypes.number.isRequired

  getInitialState: ->
    files: null

  componentDidMount: ->
    @context.putio.transfers.list(@props.directory_id)
      .then (files) =>
        @setState files: files
        files
      .catch((message) => throw message)

  render: ->
    if !@state.files?
      div(null, "loading…")
    else
      div className: 'transfer-list-directory-contents',
        @state.files.map (file) ->
          if isDirectory(file)
            Directory(key: file.id, directory: file)
          else
            File(key: file.id, file: file)

isDirectory = (file) ->
  file.content_type == "application/x-directory"
