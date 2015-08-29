require 'stdlibjs/Array#first'

component = require 'reactatron/component'

Block   = require 'reactatron/Block'
Rows    = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
Link    = require 'reactatron/Link'

Rows  = require 'reactatron/Rows'
Block = require 'reactatron/Block'


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
    maxWidth: '100%'
    ':hover':
      backgroundColor: 'rgb(218,218,218)'

  onClick: (event) ->
    if @props.file.isDirectory
      event.preventDefault()
      @app.pub 'toggle directory', @props.file.id

  render: ->
    file = @props.file
    Columns @cloneProps(),
      Column {}, FileIcon(file: file, open: @props.open)
      Column grow: 1, shrink: 1,
        Link
          path: "/files/#{file.id}"
          onClick: @onClick
          style:
            overflow: 'hidden'
            textOverflow: 'ellipsis'
          file.name

Column = Block.extendStyledComponent 'Column',
  whiteSpace: 'nowrap'
  padding: '0.25em'

FileIcon = (props) ->
  switch
    when props.file.isVideo
      'X'
    when props.file.isDirectory
      if props.open then 'V' else '>'
    else
      '?'







DirectoryContents = component 'DirectoryContents',

  # mixins: [LoadFileMixin]

  propTypes:
    fileId: component.PropTypes.number.isRequired

  dataBindings: ->
    file:    "files/#{@props.fileId}"
    loading: "files/#{@props.fileId}/loading"

  defaultStyle:
    width: '100%'

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
