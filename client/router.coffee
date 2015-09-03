component    = require 'reactatron/component'
Router = require 'reactatron/SimpleRouter'

module.exports = (app) ->


  app.renderPage =  (page, params={}) ->
    app.set route: {page, params}

  app.router = new Router ->

    redirectTo = (path, params=@params) ->
      app.setLocation {path, params}

    renderPage = (name, params=@params) =>
      app.renderPage(name, params)

    if !app.get('loggedIn')
      renderPage 'Login'
      return

    switch
      when @match '/'              then redirectTo '/transfers'
      when @match '/bookmarks'     then redirectTo '/'
      when @match '/transfers'     then renderPage 'Transfers'
      when @match '/files'         then renderPage 'Files'
      when @match '/files/:fileId' then renderPage 'Files'
      when @match '/video/:fileId' then renderPage 'Video'
      when @match '/search'        then renderPage 'Search'
      when @match '/shows'         then renderPage 'Shows'
      when @match '/*path'         then renderPage 'NotFound'


  prevLocation = app.get('location')
  app.sub 'store:change:location', ->
    newLocation = app.get('location')
    console.log('ROUTING', {newLocation, prevLocation})
    app.router.route(newLocation)
