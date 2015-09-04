require 'stdlibjs/Array#first'
toArray = require 'stdlibjs/toArray'

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
    max: INITIAL_CHUNK_SIZE
    files: @getFiles(@props.file)


  ###
    Rect Events
  ###

  componentDidMount: ->
    @app.sub 'toggle directory', @onToggleDirectory
    @grow()


  componentWillReceiveProps: (nextProps) ->
    @reload(nextProps.file) if @props.file.id != nextProps.file.id


  componentDidUpdate: ->
    @grow()


  componentWillUnmount: ->
    @app.unsub 'toggle directory', @onToggleDirectory

  ###
    Custom Events
  ###

  onToggleDirectory: (event, fileId) ->
    ids = @state.files.map (f) -> f.id
    @reload(@props.file)


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
    !file || file.loading || file.needsLoading

  isEmpty: ->
    @props.file.fileIds.length == 0

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
    files = @state.files.map (file, index) ->
      File
        key: file.id
        file: file
        shim: index+1>max
        toggleDirectory: @toggleDirectory

    Rows @cloneProps(), files







File = component 'File',

  shouldComponentUpdate: (nextProps, nextState) ->
    a = @props.file
    b = nextProps.file
    return false if (
      @props.shim    == nextProps.shim  &&
      a.id           == b.id            &&
      a.open         == b.open          &&
      b.loading      == b.loading       &&
      b.needsLoading == b.needsLoading
    )
    @app.stats.fileRerenders++
    true

  render: ->
    return FileRow() if @props.shim
    {file} = @props
    props = @extendProps
      style:
        marginLeft: "#{file.depth}em"
    FileRow props,

      Block style:{ flexShrink: 1, overflow:'hidden' },
        FileLink
          file: file
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
        DeleteFileButton file: file, tabIndex: -1



FileRow = Columns.withStyle 'FileRow',
  minHeight: '24px'
  whiteSpace: 'nowrap'
  padding: '0.25em 0.5em'
  ':hover':
    backgroundColor: '#DFEBFF'
  ':active':
    backgroundColor: '#DFEBFF'

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


LinkToFileOnPutio = (props) ->
  props.href = if props.file.isVideo
    "https://put.io/file/#{props.file.id}"
  else
    "https://put.io/your-files/#{props.file.id}"
  props.glyph ||= 'circle'
  props.title ||= 'open at put.io'
  IconLink(props)


DeleteFileButton = (props) ->
  props.onClick = (event) ->
    console.log('would delete', props.file)
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

