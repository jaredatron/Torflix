#= require 'Router'

App.router = new Router ->
  @match '/',               redirectTo: '/shows'
  @match '/shows',          component: 'ShowsPage'
  @match '/shows/:show_id', component: 'ShowPage'
  @match '/transfers',      component: 'TransfersPage'
  @match '/files',          component: 'FilesPage'
  @match '/search',         component: 'SearchPage'
  @match '/waiting-for',    component: 'WaitingForPage'
  @match '/video/:file_id', component: 'VideoPage'
  @match '/*path',          component: 'PageNotFound'
