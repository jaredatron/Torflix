#= require 'ReactPromptMixin'

component 'ShowsPage',

  contextTypes:
    putio: React.PropTypes.object.isRequired
    params: React.PropTypes.object.isRequired
  
  render: ->
    {div, span} = DOM
    # @context.putio.transfers
    div(null, 'Shows page')