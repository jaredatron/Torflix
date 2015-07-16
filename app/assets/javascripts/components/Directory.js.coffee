#= require 'mixins/DepthMixin'

component 'Directory',

  mixins: [DepthMixin]

  propTypes:
    directory: React.PropTypes.object.isRequired


  componentDidMount: ->
    putio.files.on("change:#{@props.directory.id}", @forceUpdate)

  componentWillUnmount: ->
    putio.files.removeListener("change:#{@props.directory.id}", @forceUpdate)

  getInitialState: ->
    expanded: @props.expanded

  toggle: ->
    @setState expanded: !@state.expanded

  chevron: ->
    DOM.Glyphicon
      className: 'Directory-status-icon File-icon', 
      glyph: if @state.expanded then 'chevron-down'else 'chevron-right'

  render: ->
    {div, ActionLink, FileSize} = DOM

    div className: 'File Directory',
      div className: 'File-row flex-row',
        div(style: @depthStyle())
        @chevron()
        ActionLink
          className: 'File-name flex-spacer'
          onClick: @toggle
          @props.directory.name
        div 
          className: 'File-size'
          FileSize(size: @props.directory.size)

        DOM.DeleteFileLink file: @props.directory

      if @state.expanded
        DOM.DirectoryContents(directory_id: @props.directory.id)


