component = require 'reactatron/component'
Block = require 'reactatron/Block'
Rows = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
RemainingSpace = require 'reactatron/RemainingSpace'
Layout = require '../components/Layout'
File = require '../components/File'
Button = require '../components/Button'
Icon = require '../components/Icon'

module.exports = component 'FilesPage',

  propTypes:
    fileId: component.PropTypes.string

  render: ->
    fileId = Number(@props.fileId || 0)
    if file = @app.get("files/#{fileId}")
      title = fileId == 0 && 'All Files' || file.name
      title = Header {}, title
    Layout {},
      Rows style: {padding: '0.5em', overflowY: 'scroll'},
        Columns {},
          title
          RemainingSpace {}
          ReloadButton {}
        File.DirectoryContents key: fileId, fileId: fileId




Header = Block.withStyle 'Header',
  fontSize: '150%'
  marginBottom: '0.75em'


ReloadButton = component 'ReloadButton', (props) ->
  props.onClick = =>
    @app.pub 'reload file', props.fileId

  Button props, 'reload'
