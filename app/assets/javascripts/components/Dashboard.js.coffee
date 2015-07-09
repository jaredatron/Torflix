#= require 'ReactPromptMixin'

component 'Dashboard',

  # mixins: [ReactPromptMixin]

  contextTypes:
    # putio: React.PropTypes.object.isRequired
    path:   React.PropTypes.string.isRequired
    params: React.PropTypes.object.isRequired
  
  render: ->
    {div, span} = DOM

    

    @context.putio.transfers
    div(null, 'Dashboard')