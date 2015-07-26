#= require 'ReactPromptMixin'

component 'ShowPageLayout',

  render: ->
    DOM.div
      className: Classnames('ShowPageLayout', @props.className)
      DOM.ShowSearchForm()
      @props.children
