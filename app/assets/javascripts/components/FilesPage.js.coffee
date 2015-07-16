#= require 'ReactPromptMixin'

component 'FilesPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  getInitialState: ->
    sortBy: 'name'
  
  render: ->
    DOM.DirectoryContents
      directory_id: 0
      sortBy: @state.sortBy