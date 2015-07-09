#= require 'ReactPromptMixin'

component 'TransfersPage',

  mixins: [ReactPromptMixin]

  contextTypes:
    putio: React.PropTypes.object.isRequired
    params: React.PropTypes.object.isRequired
  
  render: ->
    DOM.TransfersList()