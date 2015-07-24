#= require 'ReactPromptMixin'

component 'FilesPage',

  mixins: [ReactPromptMixin]

  contextTypes:
    params: React.PropTypes.object.isRequired

  getInitialState: ->
    sortBy:    Location.params.sortBy    || 'name' # created_at | name | size
    sortOrder: Location.params.sortOrder || 'asc'  # asc | desc

  controlsChange: (state) ->
    @setState state

  render: ->
    DOM.div
      className: 'FilesPage'

      Controls
        sortBy:    @state.sortBy
        sortOrder: @state.sortOrder

      DOM.DirectoryContents
        directory_id: 0
        sortBy:       @state.sortBy
        sortOrder:    @state.sortOrder

      @renderPrompt()


Controls = component
  displayName: 'FilesPage-Controls'

  propTypes:
    sortBy:    React.PropTypes.string.isRequired
    sortOrder: React.PropTypes.string.isRequired
    onChange:  React.PropTypes.func.isRequired

  sortByChange: ->
    @props.onChange(
      sortBy:    @refs.sortBy.getDOMNode().value
      sortOrder: @refs.sortOrder.getDOMNode().value
    )

  render: ->
    {div, select, option} = DOM
    div
      className: 'FilesPage-Controls'

      select
        ref: 'sortBy'
        onChange: @sortByChange
        option value: 'name',       'Name'
        option value: 'created_at', 'Created at'
        option value: 'size',       'Size'

      select
        ref: 'sortBy'
        onChange: @onChange
        option value: 'name',       'Name'
        option value: 'created_at', 'Created at'
