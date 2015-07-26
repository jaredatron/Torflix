#= require 'ReactPromptMixin'

component 'ShowPageLayout',

  render: ->
    DOM.div
      className: Classnames('ShowPageLayout', @props.className)
      DOM.ShowSearchForm(autofocus: true)
      @props.children
