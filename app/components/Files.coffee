React = require 'react'
component = require '../component'
PromiseStateMachine = require './PromiseStateMachine'
{DirectoryContents} = require './FileList'

module.exports = component 'Files',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  render: ->
    DirectoryContents(directory_id: 0)
