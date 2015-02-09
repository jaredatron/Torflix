React = require 'react'
component = require '../component'
ActionLink = require './ActionLink'
DownloadLink = require './DownloadLink'
Glyphicon = require 'react-bootstrap/Glyphicon'
LinkToVideoPlayerModal = require './LinkToVideoPlayerModal'
PromiseStateMachine = require './PromiseStateMachine'
DeleteLink = require './DeleteLink'
FileSize = require './FileSize'

{div, span, a, pre} = React.DOM

isDirectory = (file) ->
  file.content_type == "application/x-directory"

module.exports = component 'FileList',

  mixins: [DepthMixin]

  contextTypes:
    putio: React.PropTypes.any.isRequired

  propTypes:
    file_id: React.PropTypes.number.isRequired

  getInitialState: ->
    loading: true
    error: null

  render: ->
    PromiseStateMachine
      promise: @context.putio.files.get(@props.file_id)
      loaded: @renderFile

  renderFile: (file) ->
    div className: 'FileList',
      if isDirectory(file)
        DirectoryContents(directory_id: @props.file_id)
      else
        File(file: file)

DepthMixin =

  contextTypes:
    depth: React.PropTypes.number

  childContextTypes:
    depth: React.PropTypes.number

  getChildContext: ->
    depth: @depth() + 1

  depth: ->
    @context.depth || 0



File = component 'FileList-File',

  mixins: [DepthMixin]

  propTypes:
    file: React.PropTypes.object.isRequired

  isVideo: ->
    /\.(mkv|mp4|avi)$/.test @props.file.name

  isNew: ->
    !@props.file.first_accessed_at?

  name: ->
    name = span(null, @props.file.name)
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

  newIcon: ->
    if @isNew()
      div className: 'FileList-File-newIcon', Glyphicon(glyph:'asterisk')

  size: ->
    div className: 'FileList-File-size', FileSize(size: @props.file.size)

  render: ->

    div className: 'FileList-File',
      div className: 'FileList-row',
        @name()
        @newIcon()
        @size()
        DeleteFileLink file: @props.file




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
    div className: 'FileList-Directory',
      div className: 'FileList-row',
        ActionLink
          style: { paddingLeft: "#{@depth()}em" }
          className: 'FileList-File-name'
          onClick: @toggle,
          @chevron(),
          @props.directory.name

        DeleteFileLink file: @props.directory

      if @state.expanded
        DirectoryContents(directory_id: @props.directory.id)



DirectoryContents = component 'FileList-DirectoryContents',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  propTypes:
    directory_id: React.PropTypes.number.isRequired

  childContextTypes:
    parentDirectory: React.PropTypes.object

  getChildContext: ->
    parentDirectory: this

  render: ->
    console.log('RENDERING', @props.directory_id)
    PromiseStateMachine
      promise: @context.putio.files.list(@props.directory_id)
      loaded: @renderFiles

  reload: ->
    console.log('RELOADING', @props.directory_id)
    @context.putio.files.clearCache(@props.directory_id)
    @forceUpdate()

  renderFiles: (files) ->
    console.log('RENDERING FILES', @props.directory_id)
    if @props.directory_id == 264982789
      debugger
    div className: 'FileList-DirectoryContents',
      if files.length > 0
        files.map @renderFile
      else
        div(className: 'empty', 'empty')

  renderFile: (file) ->
    if isDirectory(file)
      Directory(key: file.id, directory: file)
    else
      File(key: file.id, file: file)


DeleteFileLink = component 'FileList-DeleteFileLink',

  contextTypes:
    putio: React.PropTypes.any.isRequired
    parentDirectory: React.PropTypes.object

  propTypes:
    file: React.PropTypes.object.isRequired

  onDelete: ->
    @context.putio.files.delete(@props.file.id).then =>
      if @context.parentDirectory
        @context.parentDirectory.reload()

  render: ->
    DeleteLink
      onDelete: @onDelete
      question: =>
        "Are you sure you want to delete #{@props.file.name}?"



module.exports.FileList = FileList
module.exports.File = File
module.exports.Directory = Directory
module.exports.DirectoryContents = DirectoryContents
