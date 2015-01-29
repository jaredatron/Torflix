React = require 'react'
component = require '../../component'
PromiseStateMachine = require '../PromiseStateMachine'
isDirectory = require './isDirectory'
File = require './File'
Directory = require './Directory'

{div, span, a} = React.DOM

module.exports = component 'FileList-DirectoryContents',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  propTypes:
    directory_id: React.PropTypes.number.isRequired

  render: ->
    PromiseStateMachine
      promise: @context.putio.transfers.list(@props.directory_id)
      loaded: @renderFiles

  renderFiles: (files) ->
    div className: 'FileList-DirectoryContents',
      if files.length > 0
        files.map @renderFile
      else
        div(className: 'empty', 'empty')

  renderFile: (file) ->
    if isDirectory(file)
      Directory(key: file.id, directory: file)
    else
      File(key: file.id, file: file)
