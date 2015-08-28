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
    if fileId = @props.file_id
      Layout {},
        File
          fileId: fileId
          style:
            padding: '1em'
    else
      Layout {},
        DirectoryContents fileId: 0


LoadFileMixin =
  propTypes:
    fileId: component.PropTypes.number.isRequired

  loadFile: ->
    @app.pub 'load file', @props.fileId

  getFile: ->
    @get("files/#{@props.fileId}")

  setFile: (file) ->
    @app.set "files/#{@props.fileId}": file

  componentDidMount: ->
    @loadFile() unless @getFile()


File = component 'File',

  mixins: [LoadFileMixin]

  # onClick: (event) ->


  defaultStyle:
    ':hover':
      backgroundColor: 'rgb(218,218,218)'

  toggle: (event) ->
    event.preventDefault()
    file = @getFile()
    file.open = !file.open
    @setFile(file)


  render: ->
    file = @getFile()

    if !file
      return Block @cloneProps(), Text({}, 'file not found or loading')

    if isDirectory(file) && file.open
      contents = DirectoryContents
        fileId: file.id
        style:
          marginLeft: '1em'

    Rows @cloneProps(),
      Columns {},
        Column {}, FileIcon(file: file)
        Column grow: 1,
          Link
            path: "/files/#{file.id}"
            onClick: @toggle
            file.name
        Column {}, FileIcon(file: file)
        Column {}, FileIcon(file: file)
        Column {}, FileIcon(file: file)
        Column {}, FileIcon(file: file)
      contents


Column = Block.extendStyledComponent 'Column',
  padding: '0.25em'

FileIcon = component 'FileName', ->
  file = @props.file
  switch
    when isVideo(file)
      Text({}, 'V')
    when isDirectory(file)
      Text({}, 'D')
    else
      Text({}, '?')

# FileName = component 'FileName', ->
#   file = @props.file
#   switch
#     when isVideo(file)

#     when isDirectory(file)
#       Link path: "/files/#{file.id}", file.name
#     else
#       Text({}, file.name)





DirectoryContents = component 'DirectoryContents',

  mixins: [LoadFileMixin]

  defaultStyle:
    width: '100%'

  componentDidMount: ->
    file = @getFile()
    if file && isDirectory(file) && !file.fileIds
      @app.pub 'load directory contents', @props.fileId

  render: ->
    file = @getFile()
    if file && isDirectory(file) && file.fileIds
      files = file.fileIds.map (fileId) ->
        File key: fileId, fileId: fileId
    Rows @cloneProps(), files




isVideo = (file) ->
  /\.(mkv|mp4|avi)$/.test file.name

isDirectory = (file) ->
  file.content_type == "application/x-directory"
