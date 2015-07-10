#= require 'ReactPromptMixin'

component 'Layout',

  render: ->
    {div, span, Navbar} = DOM
    div
      className: 'Layout layer flex-column layer-scroll-y'
      Navbar()
      @props.children
