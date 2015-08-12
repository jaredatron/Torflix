require('./App').router.map ->
  @match '/',               @redirectTo('/transfers')
  # @match '/',               redirectTo: '/transfers'
  # @match '/shows',          component: 'ShowsPage'
  # @match '/shows/search',   component: 'ShowsSearchPage'
  # @match '/shows/:show_id', component: 'ShowPage'
  # @match '/transfers',      component: 'TransfersPage'
  # @match '/files',          component: 'FilesPage'
  # @match '/files/search',   component: 'FilesSearchPage'
  # @match '/search',         component: 'TorrentsSearchPage'
  # @match '/autoplay',       component: 'AutoplayPage'
  # @match '/video/:file_id', component: 'VideoPage'
  @match '/*path',          component: require('./components/PageNotFound')



