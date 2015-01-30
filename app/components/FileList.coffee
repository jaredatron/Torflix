React = require 'react'
component = require '../component'
ActionLink = require './ActionLink'
DownloadLink = require './DownloadLink'
Glyphicon = require 'react-bootstrap/Glyphicon'
LinkToVideoPlayerModal = require './LinkToVideoPlayerModal'
PromiseStateMachine = require './PromiseStateMachine'

{div, span, a} = React.DOM

isDirectory = (file) ->
  file.content_type == "application/x-directory"

module.exports = component 'FileList',

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
    depth: (@context.depth||0) + 1

  depth: ->
    @context.depth



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
      div className: 'FileList-File-newIcon', 'NEW!'

  size: ->
    div className: 'FileList-File-size', humanFileSize(@props.file.size)

  deleteLink: ->
    ActionLink
      className: 'FileList-File-deleteLink'
      Glyphicon glyph: 'remove'

  render: ->
    console.log(@props.file)

    div className: 'FileList-File',
      @name()
      @newIcon()
      @size()
      @deleteLink()




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

  mixins: [DepthMixin]

  contextTypes:
    putio: React.PropTypes.any.isRequired

  propTypes:
    directory_id: React.PropTypes.number.isRequired

  childContextTypes:
    depth: React.PropTypes.number

  render: ->
    PromiseStateMachine
      promise: @context.putio.transfers.list(@props.directory_id)
      loaded: @renderFiles

  renderFiles: (files) ->
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



module.exports.FileList = FileList
module.exports.File = File
module.exports.Directory = Directory
module.exports.DirectoryContents = DirectoryContents


humanFileSize = (size) ->
  i = Math.floor( Math.log(size) / Math.log(1024) )
  return ( size / Math.pow(1024, i) ).toFixed(2) * 1 + ['B', 'kB', 'MB', 'GB', 'TB'][i]



