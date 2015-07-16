#= require 'mixins/DepthMixin'

SORTERS =

  created_at: (a, b) ->
    a = Date.parse(a.created_at)
    b = Date.parse(b.created_at)
    if a < b then 1 else if a > b then -1 else 0

  name: (a, b) ->
    a = a.name.toLowerCase()
    b = b.name.toLowerCase()
    if a < b then -1 else if a > b then 1 else 0

  size: (a, b) ->
    a = a.size
    b = b.size
    if a < b then 1 else if a > b then -1 else 0


# TODO dry up this duplicate
isDirectory = (file) ->
  file.content_type == "application/x-directory"


component 'DirectoryContents',

  propTypes:
    directory_id: React.PropTypes.number.isRequired
    sortBy:       React.PropTypes.any

  childContextTypes:
    parentDirectory: React.PropTypes.object

  getDefaultProps: ->
    sortBy: 'name'

  getChildContext: ->
    parentDirectory: this

  render: ->
    PromiseStateMachine
      promise: putio.files.list(@props.directory_id)
      loading: -> DOM.div(null, 'loading...')
      loaded: @renderFiles

  reload: ->
    putio.files.uncache(@props.directory_id)
    @forceUpdate()

  renderFiles: (files) ->
    console.log('renderFiles:', files)
    sorter = @props.sortBy
    sorter = SORTERS[sorter] if typeof sorter == 'string'

    DOM.div className: 'FileList-DirectoryContents',
      if files.length > 0
        files.sort(sorter).map(@renderFile)
      else
        DOM.div(className: 'empty', 'empty')

  renderFile: (file) ->
    if isDirectory(file)
      Directory(key: file.id, directory: file)
    else
      DOM.FileListMember(key: file.id, file: file)



Directory = component
  displayName: 'DirectoryContents-Directory',

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
      className: 'FileList-Directory-status-icon', 
      glyph: if @state.expanded then 'chevron-down'else 'chevron-right'

  render: ->
    {div, ActionLink, FileSize} = DOM

    div className: 'FileList-Directory',
      div className: 'FileList-row flex-row',
        @chevron()
        ActionLink
          className: 'FileList-Directory-name'
          onClick: @toggle
          @props.directory.name
        div 
          className: 'FileList-Directory-size'
          FileSize(size: @props.directory.size)

        DOM.DeleteFileLink file: @props.directory

      if @state.expanded
        DOM.DirectoryContents(directory_id: @props.directory.id)


