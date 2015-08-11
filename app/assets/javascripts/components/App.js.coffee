component 'App',

  getInitialState: ->
    App.state()

  onChange: ->
    @setState App.state()

  componentDidMount: ->
    Location.on('change', @onChange)
    App.session.on('change:put_io_access_token', @onChange)

  componentWillUnmount: ->
    App.session.removeListener('change', @onChange)
    Location.removeListener('change', @onChange)

  render: ->
    console.info('APP RENDER', @state)

    {div, Login, Layout} = DOM

    return Login() if !@state.loggedIn

    Page = if @state.params.redirectTo?
      setTimeout => Location.setPath(@state.params.redirectTo)
      (=> DOM.div(null, "redirecting to #{@state.params.redirectTo}"))
    else
      DOM[@state.params.component] || (=>
        DOM.div(null, "ERROR: routed component not found: #{@state.params.component}")
      )

    Layout(null, Page())


