#= require 'ReactPromptMixin'

component 'VideoPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  render: ->
    DOM.div
      className: 'VideoPage'

      PromiseStateMachine
        promise: App.putio.files.get(@context.params.file_id)
        loading: =>
          DOM.div(null, 'loading...')
        loaded: (file) =>
          DOM.VideoPlayer(file: file)


