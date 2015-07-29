#= require 'ReactPromptMixin'

component 'FilesPage',

  mixins: [ReactPromptMixin]

  contextTypes:
    params: React.PropTypes.object.isRequired

  render: ->
    sortBy    = Location.params.sortBy    || 'size' # created_at | name | size
    sortOrder = Location.params.sortOrder || 'asc'  # asc | desc
    DOM.div
      className: 'FilesPage'

      Controls
        sortBy:    sortBy
        sortOrder: sortOrder

      DOM.DirectoryContents
        directory_id: 0
        sortBy:       sortBy
        sortOrder:    sortOrder

      @renderPrompt()



Controls = component
  displayName: 'FilesPage-Controls'

  propTypes:
    sortBy:    React.PropTypes.string.isRequired
    sortOrder: React.PropTypes.string.isRequired

  sortByChange: ->
    Location.updateParams sortBy: @refs.sortBy.getDOMNode().value

  sortOrderChange: ->
    Location.updateParams sortOrder: @refs.sortOrder.getDOMNode().value

  render: ->
    {div, select, option, FilesSearchForm} = DOM
    div
      className: 'flex-row flex-align-items-center'

      FilesSearchForm()

      div className: 'flex-spacer'


      select
        ref: 'sortBy'
        onChange: @sortByChange
        value: @props.sortBy
        option value: 'name',       'Name'
        option value: 'created_at', 'Created at'
        option value: 'size',       'Size'

      select
        ref: 'sortOrder'
        onChange: @sortOrderChange
        value: @props.sortOrder
        option value: 'asc',  'Asc'
        option value: 'desc', 'Desc'
