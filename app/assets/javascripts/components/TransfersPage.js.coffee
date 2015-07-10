#= require 'ReactPromptMixin'

component 'TransfersPage',

  mixins: [ReactPromptMixin]

  contextTypes:
    params: React.PropTypes.object.isRequired
  
  render: ->
    DOM.div
      className: 'TransfersPage'
      DOM.AddTorrentForm()
      DOM.TransfersList()
      @renderPrompt()