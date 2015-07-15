component 'TorrentSearchResults',

  propTypes:
    query: React.PropTypes.string.isRequired
    
  render: ->
    DOM.div
      className: 'TorrentSearchResults'
      PromiseStateMachine
        promise: Torrent.search(@props.query)
        loaded: (results) =>
          DOM.div
            results.map (result, index) ->
              DOM.div
                key: index
                result.title
      
