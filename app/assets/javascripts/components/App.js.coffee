#= require 'session'
#= require 'Putio'
#= require 'Location'
#= require 'router'

getState = ->
  path:     Location.path
  params:   router.pageFor(Location.path, Location.params)
  loggedIn: !!session('put_io_access_token')


component 'App',
  
  childContextTypes:
    path:     React.PropTypes.string.isRequired
    params:   React.PropTypes.object.isRequired

  getChildContext: ->
    path:     @state.path
    params:   @state.params

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
    console.info('APP RENDER', @state)

    {div, Login, Layout} = DOM

    return Login() if !@state.loggedIn
      
    Page = if @state.params.redirectTo?
      setTimeout -> Location.setPath(@state.params.redirectTo)
      DOM.div(null, "redirecting to #{@state.params.redirectTo}")
    else
      DOM[@state.params.component] || (=>
        DOM.div(null, "ERROR: routed component not found: #{@state.params.component}")
      )

    Layout(null, Page())





