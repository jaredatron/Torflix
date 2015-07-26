#= require 'ReactPromptMixin'

component 'ShowsSearchPage',

  mixins: [ReactPromptMixin]

  contextTypes:
    params: React.PropTypes.object.isRequired

  render: ->
    DOM.ShowPageLayout
      className: 'ShowsSearchPage'
      DOM.ShowSearchResults(query: @context.params.s)
