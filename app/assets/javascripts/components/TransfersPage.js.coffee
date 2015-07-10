#= require 'ReactPromptMixin'

component 'TransfersPage',

  mixins: [ReactPromptMixin]

  contextTypes:
    putio: React.PropTypes.object.isRequired
    params: React.PropTypes.object.isRequired
  
  render: ->
    DOM.div
      className: 'TransfersPage'
      DOM.AddTorrentForm()
      DOM.TransfersList()
      @renderPrompt()