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
    id = @props.fileId || 0
    @app.pub('load file', {id})

  componentWillReceiveProps: (nextProps) ->
    nextFileId = nextProps.fileId || 0
    @app.pub('load file', id: nextFileId) if @props.fileId != nextFileId

  render: ->
    fileId = @props.fileId || 0
    file = @state.file
    if !file?
      return Layout {},
        Block {}, 'Loading...'

    console.info('file', fileId, file)

    title = file.id == 0 && 'All Files' || file.name
    Layout {},
      Rows style: {overflowY: 'scroll'},
        Columns style: {padding:'0.5em'},
          Header {}, title
          RemainingSpace {}
          ReloadButton file: file

        if file.isDirectory
          Directory file: file
        else
          File file: file




Header = Block.withStyle 'Header',
  fontSize: '150%'
  marginBottom: '0.75em'


ReloadButton = component 'ReloadButton', (props) ->
  props.onClick = =>
    @app.pub 'reload file', props.file

  Button props, 'reload'




File = component 'File',
  render: ->
    file = @props.file
    Rows {},
      Object.keys(file).sort().map (key) ->
        Columns key:key,
          Block {style:{flexBasis:'200px'}}, key
          Block {}, JSON.stringify(file[key])

