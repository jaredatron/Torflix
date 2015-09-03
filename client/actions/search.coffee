Torrent = require '../Torrent'

module.exports = (app) ->

  app.sub 'search for torrents', (event, query) ->
    searchForTorrents(query)


  app.sub 'add search result', (event, result) ->
    addSearchResult(result)


  searchForTorrents = (query) ->
    console.log "%cSearching for #{query}", 'font-size: 120%'

    storeKey = "search/#{query}"
    # search = app.get(storeKey)
    # return if search # && (Date.now() - search.queriedAt) > 2000
    search =
      query: query
      queriedAt: Date.now()
    app.set "#{storeKey}": search
    # TODO expire these search results
    # app.store.expire "#{storeKey}": search


    Torrent.search(query).then (results) ->
      search.results = results
      app.set "#{storeKey}": search



  addSearchResult = (result) ->
    console.log "%cAdding search result: #{result.title}", 'font-size: 120%'
    Torrent.get(result.id).then (torrent) =>
      app.pub 'add transfer', torrent.magnet_link
