component 'LogoutButton',

  logout: (event) ->
    event.preventDefault()
    App.session('put_io_access_token', null)

  render: ->
    {ActionLink} = DOM
    ActionLink onClick: @logout, 'Logout'
