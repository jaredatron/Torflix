getState = ->
  path:   Location.path
  params: Location.params
  putio:  Putio(session('put_io_access_token'))

component 'App',
  
  childContextTypes:
    path:   React.PropTypes.string.isRequired
    params: React.PropTypes.object.isRequired
    putio:  React.PropTypes.object

  getChildContext: ->
    path:   @state.path
    params: @state.params
    putio:  @state.putio

  getInitialState: ->
    getState()

  onChange: ->
    @setState getState()

  componentDidMount: ->
    Location.on('change', @onChange)
    session.on('change', @onChange)

  componentWillUnmount: ->
    session.removeListener('change', @onChange)
    Location.removeListener('change', @onChange)

  render: ->
    console.log('APP RENDER', @state)

    {div, Login, Dashboard} = DOM

    if @state.putio?
      Dashboard()
    else
      Login()
