#= require 'ReactPromptMixin'

component 'ShowsPage',

  contextTypes:
    params: React.PropTypes.object.isRequired
  
  render: ->
    {div, span} = DOM
    div(null, 'Shows page')