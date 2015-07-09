ReactPromptMixin =

  childContextTypes:
    setPrompt: React.PropTypes.func.isRequired
    clearPrompt: React.PropTypes.func.isRequired

  getChildContext: ->
    setPrompt: @setPrompt
    clearPrompt: @clearPrompt

  getInitialState: ->
    prompt: null

  setPrompt: (prompt) ->
    @setState prompt: prompt

  clearPrompt: (prompt) ->
    @setState prompt: null

  renderPrompt: ->
    @state.prompt() if @state.prompt?