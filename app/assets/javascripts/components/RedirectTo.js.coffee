#= require 'ReactPromptMixin'

component 'RedirectTo',

  propTypes:
    href: React.PropTypes.string.isRequired

  componentDidMount: ->
    href = @props.href
    setTimeout -> Location.set(href)

  render: ->
    DOM.div(null, "Redirecting to #{@props.href}")