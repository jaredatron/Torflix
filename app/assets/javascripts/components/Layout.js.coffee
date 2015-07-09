#= require 'ReactPromptMixin'

component 'Layout',

  render: ->
    {div, span, Navbar} = DOM
    # @context.putio.transfers
    div
      className: 'layout'
      Navbar()
      @props.children
