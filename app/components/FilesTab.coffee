React = require 'react'
component = require '../component'
{DirectoryContents} = require './FileList'
{div, select, option} = React.DOM

module.exports = component 'FilesTab',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  getInitialState: ->
    sortBy: 'created_at'

  onSortOrderChange: (sortBy) ->
    @setState sortBy: sortBy

  render: ->
    div
      className: 'FilesTab'
      Controls
        sortBy: @state.sortBy
        onSortOrderChange: @onSortOrderChange
      DirectoryContents
        directory_id: 0
        sortBy: @state.sortBy


Controls = component 'FilesTab-Controls',

  propTypes:
    sortBy: React.PropTypes.string.isRequired

  render: ->
    div
      className: 'flex-row'
      div className: 'flex-spacer'
      select
        value: @props.sortBy
        onChange: (event) =>
          @props.onSortOrderChange(event.target.value)
        option value: 'created_at', 'Created At'
        option value: 'size', 'Size'

