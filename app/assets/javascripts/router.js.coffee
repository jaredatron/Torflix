@router = (path, params) ->
  switch path
    when '/'          then DOM.div(null, 'Welcome :D')
    when '/shows'     then DOM.ShowsPage
    when '/transfers' then DOM.TransfersPage
    else
      DOM.div(null, 'Page not found')
    