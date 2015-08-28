require 'stdlibjs/Array#first'

component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
Box = require 'reactatron/Box'
Block = require 'reactatron/Block'
Text = require 'reactatron/Text'
Link = require 'reactatron/Link'
Layout = require '../components/Layout'
TransfersList = require '../components/TransfersList'

module.exports = component 'FilesPage',
  render: ->
    if fileId = Number(@props.file_id)
      Layout {},
        File
          fileId: fileId
          style:
            padding: '1em'
    else
      Layout {},
        DirectoryContents fileId: 0


LoadFileMixin =

  getFileId: ->
    if @props.fileId? then @props.fileId else @props.file.id

  getFile: ->
    @get "files/#{@getFileId()}"

  loadFile: ->
    @app.pub 'load file', @getFileId()

  setFile: (file) ->
    @app.set "files/#{@getFileId()}": file

  componentDidMount: ->
    @loadFile() unless @getFile()


File = component 'File',

  mixins: [LoadFileMixin]

  render: ->
    file = @getFile()

    if !file
      return Block @cloneProps(), Text({}, 'file not found or loading')

    if file.isDirectory && open = @get("/files/#{file.id}/open")
      directoryContents = DirectoryContents
        file: file
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
      key = "/files/#{@props.file.id}/open"
      @app.set "#{key}": !@get(key)


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

  mixins: [LoadFileMixin]

  defaultStyle:
    width: '100%'

  componentDidMount: ->
    file = @getFile()
    if file && file.isDirectory && !file.fileIds
      @app.pub 'load directory contents', file.id

  render: ->
    fileId = @getFileId()
    file = @getFile()
    loading = @get("files/#{fileId}/loading")

    if !file || !file.fileIds
      return if loading
        Block {}, 'Loading...'
      else
        Block {}, 'empty'

    files = file.fileIds.first(999).map (fileId) ->
      File key: fileId, fileId: fileId

    Rows @cloneProps(), files



