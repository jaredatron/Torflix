#= require 'PromiseStateMachine'

isDirectory = (file) ->
  file.content_type == "application/x-directory"

component 'FileList',

  propTypes:
    file_id: React.PropTypes.number.isRequired

  getInitialState: ->
    loading: true
    error: null

  render: ->
    PromiseStateMachine
      promise: putio.files.get(@props.file_id)
      loaded: @renderFile

  renderFile: (file) ->
    DOM.div className: 'FileList',
      if isDirectory(file)
        DirectoryContents(directory_id: @props.file_id)
      else
        File(file: file)

DepthMixin =

  contextTypes:
    depth: React.PropTypes.number

  childContextTypes:
    depth: React.PropTypes.number

  getChildContext: ->
    depth: @depth() + 1

  depth: ->
    @context.depth || 0

  depthStyle: ->
    { paddingLeft: "#{@depth()}em" }



File = component
  displayName: 'FileList-File',

  mixins: [DepthMixin]

  propTypes:
    file: React.PropTypes.object.isRequired

  isVideo: ->
    /\.(mkv|mp4|avi)$/.test @props.file.name

  isNew: ->
    !@props.file.first_accessed_at?

  newIcon: ->
    if @isNew()
      DOM.div 
        className: 'FileList-File-newIcon',
        DOM.Glyphicon(glyph:'asterisk')

  size: ->
    DOM.div 
      className: 'FileList-File-size', 
      DOM.FileSize(size: @props.file.size)

  name: ->
    if @isVideo()
      PlayVideoLink(
        className: 'flex-spacer'
        file: @props.file
      )
    else
      DOM.div(className: 'flex-spacer',
        DOM.Glyphicon(glyph:'file', className: 'FileList-File-icon'),
        DOM.span(null, @props.file.name),
      )

  render: ->
    {div} = DOM
    div className: 'FileList-File',
      div className: 'FileList-row flex-row',
        div(style: @depthStyle())
        @name()
        @newIcon()
        FileDownloadLink(file_id: @props.file.id, div(className: 'subtle-text', 'download'))
        @size()
        PutioLink(file: @props.file)
        ChromecastLink(file_id: @props.file.id)
        DeleteFileLink(file_id: @props.file.id)

ChromecastLink = component
  displayName: 'FileList-PutioLink',
  render: ->
    DOM.ExternalLink
      href: "https://put.io/file/#{@props.file_id}/chromecast?subtitle=off"
      className: 'FileList-PutioLink',
      title: 'chromecast',
      DOM.Glyphicon glyph: 'new-window'

PutioLink = component
  displayName: 'FileList-PutioLink',
  render: ->
    DOM.ExternalLink 
      href: "https://put.io/file/#{@props.file_id}"
      className: 'FileList-PutioLink',
      title: 'put.io',
      DOM.Glyphicon glyph: 'new-window'

FileDownloadLink = component
  displayName: 'FileList-FileDownloadLink',
  propTypes:
    file_id: React.PropTypes.number.isRequired
  render: ->
    props = Object.assign({}, @props)
    props.href = "https://put.io/v2/files/#{@props.file_id}/download"
    DOM.DownloadLink(props)



PlayVideoLink = component
  displayName: 'FileList-PlayVideoLink',
  propTypes:
    file: React.PropTypes.object.isRequired
  render: ->
    DOM.LinkToPlayVideo(
      className: @props.className,
      file_id: @props.file.id,
      DOM.Glyphicon(glyph:'facetime-video', className: 'FileList-File-icon'),
      @props.file.name,
    )


Directory = component
  displayName: 'FileList-Directory',

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
    Glyphicon
      className: 'FileList-Directory-status-icon', 
      glyph: if @state.expanded then 'chevron-down'else 'chevron-right'

  render: ->
    {div, ActionLink, DeleteFileLink, FileSize} = DOM

    div className: 'FileList-Directory',
      div className: 'FileList-row flex-row',
        div 
          className: 'FileList-File-size'
          FileSize(size: @props.directory.size)

        DeleteFileLink file: @props.directory

      if @state.expanded
        DirectoryContents(directory_id: @props.directory.id)


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



DirectoryContents = component
  displayName: 'FileList-DirectoryContents',

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
      File(key: file.id, file: file)


DeleteFileLink = component
  displayName: 'FileList-DeleteFileLink',

  contextTypes:
    parentDirectory: React.PropTypes.object

  propTypes:
    file: React.PropTypes.object.isRequired

  onDelete: ->
    putio.files.delete(@props.file.id).complete =>
      if @context.parentDirectory
        @context.parentDirectory.reload()

  render: ->
    DOM.DeleteLink
      onDelete: @onDelete
      question: =>
        "Are you sure you want to delete #{@props.file.name}?"
