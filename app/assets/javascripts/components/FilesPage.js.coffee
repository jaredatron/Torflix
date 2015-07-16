#= require 'ReactPromptMixin'

component 'FilesPage',

  mixins: [ReactPromptMixin]

  contextTypes:
    params: React.PropTypes.object.isRequired

  getInitialState: ->
    sortBy: 'name'
  
  render: ->
    DOM.div
      className: 'FilesPage'
      DOM.DirectoryContents
        directory_id: 0
        sortBy: @state.sortBy
      @renderPrompt()