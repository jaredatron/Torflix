#= require 'ReactPromptMixin'

component 'FilesSearchPage',

  mixins: [ReactPromptMixin]

  render: ->
    DOM.div
      className: 'FilesSearchPage'
      DOM.FilesSearchForm
      DOM.FilesSearchResults(query: Location.params.s)
