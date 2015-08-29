component = require 'reactatron/component'
Layout = require '../components/Layout'
File = require '../components/File'

module.exports = component 'FilesPage',

  render: ->
    if fileId = Number(@props.fileId)
      Layout {},
        File
          fileId: fileId
          style:
            padding: '1em'
    else
      Layout {},
        File.DirectoryContents fileId: 0



