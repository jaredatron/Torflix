component = require 'reactatron/component'

Block   = require 'reactatron/Block'
Rows    = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
Link    = require 'reactatron/Link'

LoadFileMixin = require '../mixins/LoadFileMixin'

DirectoryContents = null

module.exports = component 'File',

  mixins: [LoadFileMixin]

  render: ->
    file = @getFile()

    if !file
      return Block @cloneProps(), Text({}, 'file not found or loading')

    if file.isDirectory && open = @get("/files/#{file.id}/open")
      DirectoryContents ||= require('./DirectoryContents')
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
