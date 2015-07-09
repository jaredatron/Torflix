component 'Login',
  render: ->
    {div, h1, LoginButton} = DOM

    div(null,
      h1(null, 'Welcome to the put.io app.')
      LoginButton()
    )

