#= require ReactPromptMixin
#= require Show

component 'ShowsPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  render: ->
    DOM.ShowPageLayout()

