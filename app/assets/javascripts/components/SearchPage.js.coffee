#= require 'ReactPromptMixin'

component 'SearchPage',

  mixins: [ReactPromptMixin]

  contextTypes:
    params: React.PropTypes.object.isRequired
  
  render: ->
    DOM.div
      className: 'SearchPage'
      DOM.TorrentSearchResults(query: @context.params.s)
