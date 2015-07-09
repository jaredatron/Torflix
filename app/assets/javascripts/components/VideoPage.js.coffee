#= require 'ReactPromptMixin'

component 'VideoPage',

  contextTypes:
    path:   React.PropTypes.string.isRequired
    params: React.PropTypes.object.isRequired


  render: ->
    DOM.div(null, "Video: #{@context.params.file_id}")