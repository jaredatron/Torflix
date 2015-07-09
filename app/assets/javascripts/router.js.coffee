@router = (path, params) ->
  switch path
    when '/'               then DOM.RedirectTo(href: '/shows')
    when '/shows'          then DOM.ShowsPage()
    when '/transfers'      then DOM.TransfersPage()
    when '/video/:file_id' then DOM.VideoPage()
    else DOM.PageNotFound
      
    