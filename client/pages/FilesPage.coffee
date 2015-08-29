component = require 'reactatron/component'
Block = require 'reactatron/Block'
Rows = require 'reactatron/Rows'
Layout = require '../components/Layout'
File = require '../components/File'

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
        title
        File.DirectoryContents key: fileId, fileId: fileId




Header = Block.withStyle 'Header',
  fontSize: '150%'
  marginBottom: '0.75em'
