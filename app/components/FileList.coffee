React        = require 'react'
component    = require '../component'
ActionLink   = require './ActionLink'
DownloadLink = require './DownloadLink'
Glyphicon    = require 'react-bootstrap/Glyphicon'

LinkToVideoPlayerModal = require './LinkToVideoPlayerModal'

{div, span, a} = React.DOM

isDirectory = (file) ->
  file.content_type == "application/x-directory"

module.exports = component 'FileList',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  propTypes:
    file_id: React.PropTypes.number.isRequired

  childContextTypes:
    depth: React.PropTypes.number.isRequired

  getChildContext: ->
    depth: 0

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

DepthMixin =

  contextTypes:
    depth: React.PropTypes.number.isRequired

  childContextTypes:
    depth: React.PropTypes.number.isRequired

  getChildContext: ->
    depth: @context.depth + 1

  depth: ->
    @context.depth



File = component 'FileList-File',

  mixins: [DepthMixin]

  propTypes:
    file: React.PropTypes.object.isRequired

  isVideo: ->
    /\.(mkv|mp4|avi)$/.test @props.file.name

  render: ->
    name = span(null, @props.file.name)

    div
      className: 'FileList-File',
      if @isVideo()
        LinkToVideoPlayerModal
          style: { paddingLeft: "#{@depth()}em" }
          className: 'FileList-File-name'
          file_id: @props.file.id
          Glyphicon(glyph:'facetime-video', className: 'FileList-File-icon')
          name
      else
        DownloadLink
          style: { paddingLeft: "#{@depth()}em" }
          href: "https://put.io/v2/files/#{@props.file.id}/download"
          className: 'FileList-File-name'
          Glyphicon(glyph:'file', className: 'FileList-File-icon')
          name



Directory = component 'FileList-Directory',

  mixins: [DepthMixin]

  propTypes:
    directory: React.PropTypes.object.isRequired

  getInitialState: ->
    expanded: @props.expanded

  toggle: ->
    @setState expanded: !@state.expanded

  chevron: ->
    if @state.expanded
      Glyphicon(className:'FileList-Directory-status-icon', glyph:'chevron-down')
    else
      Glyphicon(className:'FileList-Directory-status-icon', glyph:'chevron-right')

  render: ->
    div className: 'FileList-File FileList-Directory',
      ActionLink
        style: { paddingLeft: "#{@depth()}em" }
        className: 'FileList-File-name'
        onClick: @toggle,
        @chevron(),
        @props.directory.name

      if @state.expanded
        DirectoryContents(directory_id: @props.directory.id)



DirectoryContents = component 'FileList-DirectoryContents',

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
      div className: 'FileList-DirectoryContents'
    else
      div className: 'FileList-DirectoryContents',
        if @isEmpty()
          div(className: 'empty', 'empty')
        else
          @state.files.map (file) ->
            if isDirectory(file)
              Directory(key: file.id, directory: file)
            else
              File(key: file.id, file: file)
