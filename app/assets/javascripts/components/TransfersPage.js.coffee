#= require 'ReactPromptMixin'

component 'TransfersPage',

  contextTypes:
    putio: React.PropTypes.object.isRequired
    params: React.PropTypes.object.isRequired
  
  render: ->
    {div, span} = DOM
    # @context.putio.transfers
    div(null, 'Transfers page')