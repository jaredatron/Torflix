#= require 'Router'
#= require 'components/RedirectTo'

@router = new Router ->
  @match '/',               redirectTo: '/shows'
  @match '/shows',          component: 'ShowsPage'
  @match '/transfers',      component: 'TransfersPage'
  @match '/video/:file_id', component: 'VideoPage'
  @match '/*path',          component: 'PageNotFound'
