React = require 'react'
component = require '../component'

ActionLink = require './ActionLink'
VideoPlayer = require './VideoPlayer'
PromiseStateMachine = require './PromiseStateMachine'

{div} = React.DOM


module.exports = component 'VideoPlayerModal',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  propTypes:
    onClose: React.PropTypes.func.isRequired
    fileId: React.PropTypes.number.isRequired

  render: ->
    div className: 'VideoPlayerModal modal', tabIndex: -1, role: 'dialog', style: {display: 'block'},
      div className: 'controls',
        ActionLink onClick: @props.onClose, 'X'

      PromiseStateMachine
        promise: @context.putio.files.get(@props.fileId)
        loaded: (file) -> VideoPlayer(file: file)
