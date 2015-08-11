#= require Route

Route.match '/',               redirectTo: '/transfers'
Route.match '/shows',          component: 'ShowsPage'
Route.match '/shows/search',   component: 'ShowsSearchPage'
Route.match '/shows/:show_id', component: 'ShowPage'
Route.match '/transfers',      component: 'TransfersPage'
Route.match '/files',          component: 'FilesPage'
Route.match '/files/search',   component: 'FilesSearchPage'
Route.match '/search',         component: 'TorrentsSearchPage'
Route.match '/autoplay',       component: 'AutoplayPage'
Route.match '/video/:file_id', component: 'VideoPage'
Route.match '/*path',          component: 'PageNotFound'
