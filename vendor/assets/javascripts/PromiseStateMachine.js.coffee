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
      DOM.span(null,"Error: #{error}")

  getInitialState: ->
    loaded: false
    error: null
    payload: null

  componentDidMount: ->
    @props.promise
      .catch (error) =>
        console.warn('ERROR caught by PromiseStateMachine')
        console.error(error)
        @setState loaded: true, error: error
      .then (payload) =>
        @setState loaded: true, payload: payload
      .catch (error) =>
        raise error

  render: ->
    switch
      when @state.error
        @props.failed(@state.error)
      when @state.loaded
        @props.loaded(@state.payload)
      else
        @props.loading()
