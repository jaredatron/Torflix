React      = require 'react'
component  = require '../component'
ActionLink = require './ActionLink'
Glyphicon  = require 'react-bootstrap/Glyphicon'

{div, span, a} = React.DOM


module.exports = component 'FileList',

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


File = component 'FileListFile',

  propTypes:
    file: React.PropTypes.object.isRequired

  render: ->
    div className: 'transfer-list-file',
      div className: 'transfer-list-file-name', @props.file.name


Directory = component 'FileListDirectory',

  propTypes:
    directory: React.PropTypes.object.isRequired

  getInitialState: ->
    expanded: @props.expanded

  toggle: ->
    @setState expanded: !@state.expanded

  chevron: ->
    if @state.expanded
      Glyphicon(className:'transfer-list-directory-status-icon', glyph:'chevron-down')
    else
      Glyphicon(className:'transfer-list-directory-status-icon', glyph:'chevron-right')

  render: ->
    div className: 'transfer-list-directory',
      ActionLink onClick: @toggle,
        @chevron(),
        span className: 'transfer-list-directory-name', @props.directory.name

      if @state.expanded
        DirectoryContents(directory_id: @props.directory.id)


DirectoryContents = component 'FileListDirectoryContents',

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

  isEmpty: ->
    @state.files.length == 0

  render: ->
    if !@state.files?
      div className: 'transfer-list-directory-contents',
        div(null, "loading…")
    else
      div className: 'transfer-list-directory-contents',
        if @isEmpty()
          div(className: 'empty', 'empty')
        else
          @state.files.map (file) ->
            if isDirectory(file)
              Directory(key: file.id, directory: file)
            else
              File(key: file.id, file: file)


isDirectory = (file) ->
  file.content_type == "application/x-directory"
