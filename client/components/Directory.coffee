require 'shouldhave/Array#first'
require 'shouldhave/Array#pluck'
toArray = require 'shouldhave/toArray'

component = require 'reactatron/component'

withStyle = require 'reactatron/withStyle'

Style   = require 'reactatron/Style'
Block   = require 'reactatron/Block'
Rows    = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
Space   = require 'reactatron/Space'
RemainingSpace   = require 'reactatron/RemainingSpace'

Rows  = require 'reactatron/Rows'
Block = require 'reactatron/Block'
Space = require 'reactatron/Space'

Link     = require './Link'
Icon     = require './Icon'
FileSize = require './FileSize'
Button = require './Button'
DeleteButton = require './DeleteButton'




IconLink = require './IconLink'
LinkToFileOnPutio = require './LinkToFileOnPutio'




RENDER_CHUNK_SIZE = 10
INITIAL_CHUNK_SIZE = RENDER_CHUNK_SIZE

module.exports = component 'Directory',

  propTypes:
    file: component.PropTypes.object.isRequired

  childContextTypes:
    toggleDirectory: component.PropTypes.func

  getChildContext: ->
    toggleDirectory: @toggleDirectory

  getInitialState: ->
    selectedFileId: null
    max: INITIAL_CHUNK_SIZE
    files: @getFiles(@props.file)


  ###
    Rect Events
  ###

  componentDidMount: ->
    @app.sub 'file changed', @onFileChange
    @grow()


  componentWillReceiveProps: (nextProps) ->
    @reload(nextProps.file) if @props.file.id != nextProps.file.id


  componentDidUpdate: ->
    @grow()


  componentWillUnmount: ->
    @app.unsub 'file changed', @onFileChange

  ###
    Events
  ###

  onFileChange: (event, data) ->
    fileId = data.id
    if @state.files.pluck('id').includes(fileId)
      @reload(@props.file)

  onFileFocus: (file) ->
    if @state.selectedFileId != file.id
      @setState selectedFileId: file.id

  onFileBlur: (file) ->
    if @state.selectedFileId == file.id
      @setState selectedFileId: null

  ###
    Actions
  ###

  reload: (file) ->
    return unless @isMounted()
    files = @getFiles(file)
    max = @state.max
    max = files.length if max > files.length
    max = INITIAL_CHUNK_SIZE if max < INITIAL_CHUNK_SIZE
    @setState max: max, files: files


  getFiles: (file)->
    flattenFilesTree(@app, file)

  toggleDirectory: (file) ->
    @app.pub 'toggle directory', file.id

  increaseMax: ->
    return unless @isMounted()
    @setState max: @state.max + RENDER_CHUNK_SIZE

  grow: ->
    setTimeout(@increaseMax, 200) if @needsToGrow()

  isLoading: ->
    {file} = @props
    !file || (!file.fileIds && (file.loading || file.needsLoading))

  isEmpty: ->
    @props.file.fileIds?.length == 0

  needsToGrow: ->
    !@isLoading() && @state.files.length > @state.max



  ###
    Render
  ###

  render: ->
    {file} = @props
    if @isLoading() then return Block @cloneProps(), 'Loading...'
    if @isEmpty()   then return Block @cloneProps(), 'empty'


    max = @state.max
    selectedFileId = @state.selectedFileId
    onFileFocus = @onFileFocus
    onFileBlur = @onFileBlur
    files = @state.files.map (file, index) ->
      File
        key: file.id
        file: file
        selected: file.id == selectedFileId
        shim: index+1>max
        onFocus: onFileFocus.bind(null, file)
        onBlur: onFileBlur.bind(null, file)

    props = @extendProps
      file: undefined
      onKeyDown: @onKeyDown

    Rows props, files







File = component 'File',

  shouldComponentUpdate: (nextProps, nextState) ->
    a = @props.file
    b = nextProps.file
    return false if (
      @props.selected == nextProps.selected  &&
      @props.shim     == nextProps.shim  &&
      a.id            == b.id            &&
      a.open          == b.open          &&
      a.loading       == b.loading       &&
      a.depth         == b.depth       &&
      a.needsLoading  == b.needsLoading
    )
    @app.stats.fileRerenders++
    true

  onKeyDown: (event) ->
    file = @props.file
    switch event.keyCode
      when 38 # up
        event.preventDefault()
        @getDOMNode().previousElementSibling?.getElementsByTagName('a')[0].focus()
      when 40 # down
        event.preventDefault()
        @getDOMNode().nextElementSibling?.getElementsByTagName('a')[0].focus()

    if file.isDirectory
      switch event.keyCode
        when 39 # right
          event.preventDefault()
          @app.pub('open directory', file.id) if !file.open
        when 37 # left
          event.preventDefault()
          @app.pub('close directory', file.id) if file.open

  deleteFile: ->
    @app.pub 'delete file', @props.file.id

  render: ->
    return FileRow() if @props.shim
    {file} = @props
    props = @extendProps
      onKeyDown: @onKeyDown
      style:
        marginLeft: "#{file.depth}em"

    if @props.selected
      props.style.backgroundColor = '#DFEBFF'

    FileRow props,

      Block style:{ flexShrink: 1, overflow:'hidden' },
        FileLink
          file: file
          className: 'Directory-FileLink'
          style:
            overflow:'hidden'
            width: '100%'
            textOverflow: 'ellipsis'

      RemainingSpace style:{ marginLeft: '1em'}

      withStyle minWidth: '20px', flexBasis: '20px', marginRight: '0.5em',
        DownloadFileLink file: file, tabIndex: -1

      withStyle minWidth: '20px', flexBasis: '20px', marginRight: '0.5em',
        LinkToFileOnPutio file: file, tabIndex: -1

      withStyle minWidth: '60px', flexBasis: '60px', overflow: 'hidden', textOverflow: 'ellipsis', textAlign: 'right',
        FileSize size: file.size, tabIndex: -1

      withStyle minWidth: '2em', flexBasis: '2em', marginLeft: '0.5em',
        DeleteFileButton file: file, tabIndex: -1, onClick: @deleteFile



FileRow = Columns.withStyle 'FileRow',
  minHeight: '24px'
  whiteSpace: 'nowrap'
  padding: '0.25em 0.5em'
  ':hover':
    backgroundColor: '#DFEBFF'
  # ':active':
  #   backgroundColor: '#DFEBFF'

FileLink = (props) ->
  switch
    when props.file.isVideo
      PlayVideoLink(props)
    when props.file.isDirectory
      DirectoryToggleLink(props)
    else
      DownloadFileLink(props, props.file.name)


LinkToFile = (props) ->
  props.path  ||= "/files/#{props.file.id}"
  props.glyph ||= 'file'
  IconLink(props, props.file.name)


PlayVideoLink = (props) ->
  props.path  ||= "/video/#{props.file.id}"
  props.glyph ||= 'play'
  IconLink props, props.file.name

DirectoryToggleLink = component 'DirectoryToggleLink',

  contextTypes:
    toggleDirectory: component.PropTypes.func.isRequired

  propTypes:
    file: component.PropTypes.object.isRequired

  onClick: (event) ->
    event.preventDefault()
    if event.altKey
      @app.setLocation "/files/#{@props.file.id}"
    else
      @context.toggleDirectory(@props.file)

  render: ->
    props = @extendProps
      glyph: if @props.file.open then 'chevron-down' else 'chevron-right'
      onClick: @onClick
    LinkToFile props

DownloadFileLink = (props, children...) ->
  props.glyph ||= 'download'
  props.title ||= 'download'
  props.href  ||= "https://put.io/v2/files/#{props.file.id}/download"
  # props.target ||= '_blank'
  IconLink(props, children...)


DeleteFileButton = (props) ->
  DeleteButton(props)





flattenFilesTree = (app, file, depth=0) ->
  files = []
  return files if !file?
  if file.isDirectory
    file.fileIds?.forEach (fileId) ->
      file = app.get("files/#{fileId}") || {}
      file.depth = depth
      files.push file
      if file.open
        files.push flattenFilesTree(app, file, depth+1)...
  files

