React = require 'react'
component = require '../../component'
DepthMixin = require './DepthMixin'
ActionLink = require '../ActionLink'
LinkToVideoPlayerModal = require '../LinkToVideoPlayerModal'
DirectoryContents = require './DirectoryContents'
Glyphicon = require 'react-bootstrap/Glyphicon'

{div, span, a} = React.DOM

debugger

module.exports = component 'FileList-Directory',

  mixins: [DepthMixin]

  propTypes:
    directory: React.PropTypes.object.isRequired

  getInitialState: ->
    expanded: @props.expanded

  toggle: ->
    @setState expanded: !@state.expanded

  chevron: ->
    if @state.expanded
      Glyphicon(className:'FileList-Directory-status-icon', glyph:'chevron-down')
    else
      Glyphicon(className:'FileList-Directory-status-icon', glyph:'chevron-right')

  render: ->
    div className: 'FileList-File FileList-Directory',
      ActionLink
        style: { paddingLeft: "#{@depth()}em" }
        className: 'FileList-File-name'
        onClick: @toggle,
        @chevron(),
        @props.directory.name

      if @state.expanded
        DirectoryContents(directory_id: @props.directory.id)



