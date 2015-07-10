#= require 'ReactPromptMixin'

component 'Layout',

  render: ->
    {div, span, Navbar} = DOM
    # @context.putio.transfers
    div
      className: 'Layout layer flex-column layer-scroll-y'
      Navbar()
      @props.children
