#= require 'ReactPromptMixin'

component 'RedirectTo',

  propTypes:
    path: React.PropTypes.string.isRequired

  componentDidMount: ->
    path = @props.path
    setTimeout -> Location.set(path)

  render: ->
    DOM.div(null, "Redirecting to #{@props.path}")