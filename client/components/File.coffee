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
    open = @state.open

    if !file
      return Block @cloneProps(), 'file not found or loading'

    if file.isDirectory && open
      directoryContents = DirectoryContents
        fileId: file.id
        style:
            marginLeft: '1em'

    Rows @cloneProps(),
      FileRow file: file, open: false
      directoryContents

FileRow = component 'FileRow',

  propTypes:
    file: component.PropTypes.object.isRequired

  defaultStyle:
    ':hover':
      backgroundColor: 'rgb(218,218,218)'

  onClick: (event) ->
    if @props.file.isDirectory
      event.preventDefault()
      @app.pub 'toggle directory', @props.file.id

  render: ->
    file = @props.file
    Columns @cloneProps(),
      Column {}, FileIcon(file: file)
      Column grow: 1,
        Link
          path: "/files/#{file.id}"
          onClick: @onClick
          file.name


Column = Block.extendStyledComponent 'Column',
  padding: '0.25em'

FileIcon = (props) ->
  switch
    when props.file.isVideo
      'V'
    when props.file.isDirectory
      'D'
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
        Block {}, 'Loading...'
      else
        Block {}, 'empty'

    files = file.fileIds.first(999).map (fileId) ->
      File key: fileId, fileId: fileId

    Rows @cloneProps(), files



File.DirectoryContents = DirectoryContents
module.exports = File
