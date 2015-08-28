require 'stdlibjs/Array#first'

component = require 'reactatron/component'

Block   = require 'reactatron/Block'
Rows    = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
Link    = require 'reactatron/Link'

Rows  = require 'reactatron/Rows'
Block = require 'reactatron/Block'


LoadFileMixin =

  getFileId: ->
    if @props.fileId? then @props.fileId else @props.file.id

  getFile: ->
    @get "files/#{@getFileId()}"

  loadFile: ->
    @app.pub 'load file', @getFileId()

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



File.DirectoryContents = DirectoryContents
module.exports = File
