#= require 'ReactPromptMixin'

component 'FilesSearchPage',

  mixins: [ReactPromptMixin]

  contextTypes:
    params: React.PropTypes.object.isRequired

  render: ->
    DOM.div
      className: 'FilesSearchPage'
      DOM.FilesSearchForm
      DOM.FilesSearchResults(query: @context.params.s)
