#= require 'Router'

App.router = new Router ->
  @match '/',               redirectTo: '/shows'
  @match '/search/shows',   component: 'SearchShowsPage'
  @match '/shows',          component: 'ShowsPage'
  @match '/shows/:show_id', component: 'ShowPage'
  @match '/transfers',      component: 'TransfersPage'
  @match '/files',          component: 'FilesPage'
  @match '/search',         component: 'SearchPage'
  @match '/autoplay',       component: 'AutoplayPage'
  @match '/video/:file_id', component: 'VideoPage'
  @match '/*path',          component: 'PageNotFound'
