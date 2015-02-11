React = require 'react'
component = require '../component'
{DirectoryContents} = require './FileList'
{div} = React.DOM

module.exports = component 'FilesTab',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  render: ->
    div
      className: 'FilesTab'
      DirectoryContents
        directory_id: 0
        sort_by: 'created_at'
