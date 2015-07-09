#= require 'ReactPromptMixin'

component 'Dashboard',

  mixins: [PromptMixin]

  contextTypes:
    # putio: React.PropTypes.object.isRequired
    path: React.PropTypes.string.isRequired
    params: React.PropTypes.string.isRequired
  
  render: ->
    {div, span} = DOM
    @context.putio.transfers
    div(null, 'Dashboard')