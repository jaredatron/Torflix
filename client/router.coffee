component    = require 'reactatron/component'
Router = require 'reactatron/SimpleRouter'

module.exports = (app) ->


  redirectTo = (path, params={}) ->
    app.setLocation {path, params}

  renderPage =  (page, path, params) ->
    app.set route: {page, path, params}

  app.router = new Router ->

    if !app.get('loggedIn')
      renderPage 'Login'
      return

    switch
      when @match '/'              then redirectTo '/transfers'
      when @match '/bookmarks'     then redirectTo '/'
      when @match '/transfers'     then renderPage 'Transfers', @path, @params
      when @match '/files'         then renderPage 'Files',     @path, @params
      when @match '/files/:fileId' then renderPage 'Files',     @path, @params
      when @match '/video/:fileId' then renderPage 'Video',     @path, @params
      when @match '/search'        then renderPage 'Search',    @path, @params
      when @match '/shows'         then renderPage 'Shows',     @path, @params
      when @match '/*path'         then renderPage 'NotFound',  @path, @params


  prevLocation = app.get('location')
  app.sub 'store:change:location', ->
    newLocation = app.get('location')
    console.log('ROUTING', {newLocation, prevLocation})
    app.router.route(newLocation)
