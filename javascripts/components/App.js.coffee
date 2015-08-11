component 'App',

  getInitialState: ->
    App.state()

  updateState: ->
    @setState App.state()

  componentDidMount: ->
    App.on('login',           @updateState)
    App.on('logout',          @updateState)
    App.on('location:change', @updateState)

  componentWillUnmount: ->
    App.session.removeListener('change', @updateState)
    # Location.removeListener('change', @updateState)

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


