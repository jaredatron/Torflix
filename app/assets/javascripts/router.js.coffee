@router = (path, params) ->
  switch path
    when '/'          then -> DOM.RedirectTo(href: '/shows')
    when '/shows'     then DOM.ShowsPage
    when '/transfers' then DOM.TransfersPage
    else DOM.PageNotFound
      
    