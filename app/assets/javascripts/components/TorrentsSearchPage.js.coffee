#= require 'ReactPromptMixin'

component 'TorrentsSearchPage',

  mixins: [ReactPromptMixin]

  contextTypes:
    params: React.PropTypes.object.isRequired

  render: ->
    DOM.div
      className: 'TorrentsSearchPage'
      DOM.TorrentSearchResults(query: @context.params.s)
