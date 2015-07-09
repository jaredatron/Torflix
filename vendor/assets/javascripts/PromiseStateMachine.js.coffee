@PromiseStateMachine = React.createFactory React.createClass
  
  displayName: 'PromiseStateMachine'

  propTypes:
    promise: React.PropTypes.object.isRequired
    loading: React.PropTypes.func
    loaded:  React.PropTypes.func.isRequired
    failed:  React.PropTypes.func

  getDefaultProps: ->
    loading: ->
      DOM.span()
    failed: (error) ->
      console.error(error)
      DOM.span(null,"Error: #{error}")

  getInitialState: ->
    loaded: false
    error: null
    payload: null

  componentDidMount: ->
    @props.promise
      .then (payload) =>
        @setState loaded: true, payload: payload
      .catch (error) =>
        @setState loaded: true, error: error

  render: ->
    switch
      when @state.error
        @props.failed(@state.error)
      when @state.loaded
        @props.loaded(@state.payload)
      else
        @props.loading()
