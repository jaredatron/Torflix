component = require 'reactatron/component'
Block = require 'reactatron/Block'
Rows = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
RemainingSpace = require 'reactatron/RemainingSpace'
Layout = require '../components/Layout'
Directory = require '../components/Directory'
Button = require '../components/Button'
Icon = require '../components/Icon'

module.exports = component 'FilesPage',

  propTypes:
    fileId: component.PropTypes.string

  getFileId: ->

  dataBindings: (props) ->
    file: "files/#{props.fileId || 0}"

  componentDidMount: ->
    @app.pub('load file', @props.fileId || 0)

  componentWillReceiveProps: (nextProps) ->
    nextFileId = nextProps.fileId || 0
    @app.pub('load file', nextFileId) if @props.fileId != nextFileId

  render: ->
    fileId = @props.fileId || 0
    file = @state.file
    # console.log('FilesPage render', fileId, file)
    if !file?
      return Layout {},
        Block {}, 'Loading...'


    title = file.id == 0 && 'All Files' || file.name
    Layout {},
      Rows style: {overflowY: 'scroll'},
        Columns style: {padding:'0.5em'},
          Header {}, title
          RemainingSpace {}
          ReloadButton fileId: file.id

        # File.DirectoryContents key: file.id, file: file
        if file.isDirectory
          Directory file: file
        else
          Block {}, "hey look a file show page :D #{file.id}"




Header = Block.withStyle 'Header',
  fontSize: '150%'
  marginBottom: '0.75em'


ReloadButton = component 'ReloadButton', (props) ->
  props.onClick = =>
    @app.pub 'reload file', props.fileId

  Button props, 'reload'
