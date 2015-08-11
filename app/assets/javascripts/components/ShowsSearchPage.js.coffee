#= require 'ReactPromptMixin'

component 'ShowsSearchPage',

  mixins: [ReactPromptMixin]

  render: ->
    DOM.ShowPageLayout
      className: 'ShowsSearchPage'
      DOM.ShowSearchResults(query: Location.params.s)
