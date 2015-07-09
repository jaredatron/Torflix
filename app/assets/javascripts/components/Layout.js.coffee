#= require 'ReactPromptMixin'

component 'Layout',

  render: ->
    {div, span} = DOM
    # @context.putio.transfers
    div
      className: 'layout'
      'Layout:'
      @props.children
