#= require 'router'

@router = new Router ->
  redirectTo = (path) ->
    DOM.RedirectTo(href: path)

  @match '/',              redirectTo('/shows')
  @match '/shows',         DOM.ShowsPage
  @match '/transfers'      DOM.TransfersPage()
  @match '/video/:file_id' DOM.VideoPage()
  @match '*',              DOM.PageNotFound
