getState = ->
  put_io_access_token: session('put_io_access_token')

component 'App',
  
  # childContextTypes:
  #   path:   React.PropTypes.object
  #   putio:  React.PropTypes.any

  # _putio: null
  # putio: ->
  #   token = @state.put_io_access_token
  #   return null unless token?
  #   @_putio = null unless @_putio && @_putio.TOKEN == token
  #   @_putio ||= putio(token)
  #   window.DEBUG_PUTIO = @_putio

  # getChildContext: ->
  #   path:  path
  #   putio: @putio()

  getInitialState: ->
    getState()

  onChange: ->
    @setState getState()

  # componentDidMount: ->
  #   session.on('change', @onChange)
  #   path.on('change', @onChange)

  # componentWillUnmount: ->
  #   session.removeListener('change', @onChange)
  #   path.removeListener('change', @onChange)

  render: ->
    window.DEBUG_APP_STATE = @state

    {div, Login} = DOM

    if @state.put_io_access_token
      div(null, 'LOGGED IN')
    else
      Login()
