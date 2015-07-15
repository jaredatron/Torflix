component 'TorrentSearchResults',

  propTypes:
    query: React.PropTypes.string.isRequired
    
  render: ->
    DOM.div
      className: 'TorrentSearchResults'
      PromiseStateMachine
        key: "query-#{@props.query}"
        promise: Torrent.search(@props.query)
        loadinf: ->
          DOM.div(null, 'loading...')
        loaded: (results) =>
          DOM.div 
            className: ''
            results.map (result, index) ->
              DOM.div
                key: index
                result.title
      
