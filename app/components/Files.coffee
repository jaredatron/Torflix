React = require 'react'
component = require '../component'
PromiseStateMachine = require './PromiseStateMachine'
{DirectoryContents} = require './FileList'

module.exports = component 'Files',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  propTypes:
    file_id: React.PropTypes.number.isRequired

  render: ->
    DirectoryContents(directory_id: 0)
