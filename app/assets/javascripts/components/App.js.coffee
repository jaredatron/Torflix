#= require 'session'
#= require 'putio'
#= require 'Location'
#= require 'router'

getState = ->
  path:     Location.path
  params:   Location.params
  loggedIn: !!session('put_io_access_token')
  putio:    Putio(session('put_io_access_token'))

component 'App',
  
  childContextTypes:
    path:     React.PropTypes.string.isRequired
    params:   React.PropTypes.object.isRequired
    putio:    React.PropTypes.object

  getChildContext: ->
    path:     @state.path
    params:   @state.params
    putio:    @state.putio

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

    {div, Login, Layout} = DOM

    return Login() if !@state.loggedIn
      
    page = router.pageFor(@state.path, @state.params)
    Layout({}, page)

    



