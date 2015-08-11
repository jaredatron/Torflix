#= require 'ReactPromptMixin'

component 'TorrentsSearchPage',

  mixins: [ReactPromptMixin]

  render: ->
    DOM.div
      className: 'TorrentsSearchPage'
      DOM.TorrentSearchResults(query: Location.params.s)
