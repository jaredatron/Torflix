require 'stdlibjs/Array#first'

component = require 'reactatron/component'

Block   = require 'reactatron/Block'
Rows    = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
Link    = require 'reactatron/Link'
Space   = require 'reactatron/Space'
RemainingSpace   = require 'reactatron/RemainingSpace'

Rows  = require 'reactatron/Rows'
Block = require 'reactatron/Block'

Icon = require './Icon'
FileSize = require './FileSize'

File = component 'File',

  # mixins: [LoadFileMixin]

  propTypes:
    fileId: component.PropTypes.number.isRequired

  dataBindings: ->
    file:    "files/#{@props.fileId}"
    loading: "files/#{@props.fileId}/loading"
    open:    "files/#{@props.fileId}/open"

  componentWillReceiveProps: (nextProps) ->
    if this.props.fileId != nextProps.fileId
      debugger

  render: ->
    file = @state.file
    loading = !!@state.loading
    open = !!@state.open

    if !file
      if loading
        return Block @cloneProps(), 'loading...'
      else
        return Block @cloneProps(), 'file not found :('


    if file.isDirectory && open
      directoryContents = DirectoryContents
        fileId: file.id
        style:
            marginLeft: '1em'

    Rows @cloneProps(),
      FileRow file: file, open: open
      directoryContents



FileRow = component 'FileRow',

  propTypes:
    file: component.PropTypes.object.isRequired
    open: component.PropTypes.bool.isRequired

  defaultStyle:
    whiteSpace: 'nowrap'
    padding: '0.25em 0.5em'
    # maxWidth: '100%'
    ':hover':
      backgroundColor: 'rgb(218,218,218)'

  onClick: (event) ->
    if @props.file.isDirectory
      event.preventDefault()
      @app.pub 'toggle directory', @props.file.id

  render: ->
    file = @props.file
    Columns @cloneProps(),
      Filelink
        file: file,
        open: @props.open
        onClick: @onClick
      RemainingSpace {}
      DownloadFileLink file: file
      Space(2)
      LinkToFileOnPutio file: file
      Space(2)
      FileSize size: file.size, style:{width: '4em'}


  Link onClick: (-> ), Icon(glyph:'download')



Filelink = (props) ->
  switch
    when props.file.isVideo
      PlayVideoLink(props)
    when props.file.isDirectory
      DirectoryToggleLink(props)
    else
      DownloadFileLink(props, props.file.name)



IconLink = (props, children...) ->
  component.mergeStyle props,
    overflow: 'hidden'
    textOverflow: 'ellipsis'

  Link props,
    Icon glyph: props.glyph, fixedWidth: true
    children...


LinkToFile = (props) ->
  props.path  ||= "/files/#{props.file.id}"
  props.glyph ||= 'file'
  IconLink(props, props.file.name)

LinkToFileOnPutio = (props) ->
  props.href = if props.file.isVideo
    "https://put.io/file/#{props.file.id}"
  else
    "https://put.io/your-files/#{props.file.id}"
  props.glyph ||= 'circle'
  props.title ||= 'open at put.io'
  IconLink(props)

PlayVideoLink = (props) ->
  props.path  ||= "/video/#{props.file.id}"
  props.glyph ||= 'play'
  IconLink props, props.file.name

DirectoryToggleLink = (props) ->
  props.glyph = props.open and 'chevron-down' or 'chevron-right'
  LinkToFile props

DownloadFileLink = (props, children...) ->
  props.glyph ||= 'download'
  props.title ||= 'download'
  props.href = "https://put.io/v2/files/#{props.file.id}/download"
  IconLink(props, children...)


DirectoryContents = component 'DirectoryContents',

  # mixins: [LoadFileMixin]

  propTypes:
    fileId: component.PropTypes.number.isRequired

  dataBindings: ->
    file:    "files/#{@props.fileId}"
    loading: "files/#{@props.fileId}/loading"

  # defaultStyle:
    # width: '100%'

  componentDidMount: ->
    file = @state.file
    if !file || (file.isDirectory && !file.fileIds)
      @app.pub 'load directory contents', @props.fileId

  render: ->
    fileId = @props.fileId
    file = @state.file
    loading = @state.loading

    if !file || !file.fileIds
      return if loading
        Block @cloneProps(), 'Loading...'
      else
        Block @cloneProps(), 'empty'

    files = file.fileIds.first(999).map (fileId) ->
      File key: fileId, fileId: fileId

    Rows @cloneProps(), files



File.DirectoryContents = DirectoryContents
module.exports = File
