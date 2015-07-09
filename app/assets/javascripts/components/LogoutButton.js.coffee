component 'LogoutButton',

  logout: (event) ->
    event.preventDefault()
    session('put_io_access_token', null)

  render: ->
    {ActionLink} = DOM
    ActionLink onClick: @logout, 'Logout'
