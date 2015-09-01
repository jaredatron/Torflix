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
SafetyButton = require './SafetyButton'




IconLink = require './IconLink'

module.exports = component 'Directory',

  propTypes:
    file: component.PropTypes.object.isRequired

  childContextTypes:
    toggleDirectory: component.PropTypes.func

  getChildContext: ->
    toggleDirectory: @toggleDirectory

  getInitialState: ->
    max: 0
    files: @getFiles()

  getFiles: ->
    flattenFilesTree(@app, @props.file)

  reload: ->
    @setState @getInitialState()

  toggleDirectory: (file) ->
    # instead of doing this with the context callback cant we just listen to any 'toggle directory' event?
    # reloading should be fast
    @app.onNext "store:change:files/#{file.id}", @rerender
    @app.pub 'toggle directory', file.id




  increaseMax: ->
    return unless @isMounted
    @setState max: @state.max + 10

  grow: ->
    setTimeout(@increaseMax, 200) if @needsToGrow()




  isLoading: ->
    {file} = @props
    !file || file.loading || file.needsLoading

  isEmpty: ->
    @props.file.fileIds.length == 0

  needsToGrow: ->
    !@isLoading() && @state.files.length > @state.max



  componentWillReceiveProps: (nextProps) ->
    @reload() if @props.file.id != nextProps.file.id

  componentDidMount: ->
    @grow()

  componentDidUpdate: ->
    @grow()

  renderFiles: (file, index) ->
    max = @state.max
    @state.files.map (file, index) ->
      File
        key: file.id
        file: file
        shim: index+1>max
        toggleDirectory: @toggleDirectory

  render: ->
    {file} = @props
    if @isLoading() then return Block @cloneProps(), 'Loading...'
    if @isEmpty()   then return Block @cloneProps(), 'empty'
    Rows @cloneProps(), @renderFiles()

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

      withStyle flexBasis: '20px', marginRight: '0.5em',
        DownloadFileLink file: file, tabIndex: -1

      withStyle flexBasis: '20px', marginRight: '0.5em',
        LinkToFileOnPutio file: file, tabIndex: -1

      withStyle flexBasis: '4em', overflow: 'hidden', textOverflow: 'ellipsis', textAlign: 'right',
        FileSize size: file.size, tabIndex: -1

      withStyle flexBasis: '2em', marginLeft: '0.5em',
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
  IconLink(props, children...)


LinkToFileOnPutio = (props) ->
  props.href = if props.file.isVideo
    "https://put.io/file/#{props.file.id}"
  else
    "https://put.io/your-files/#{props.file.id}"
  props.glyph ||= 'circle'
  props.title ||= 'open at put.io'
  IconLink(props)


DeleteFileButton = component 'DeleteFileButton',
  propTypes:
    file: component.PropTypes.object.isRequired

  defaultStyle:
    flexDirection: 'row-reverse'

  deleteFile: (event) ->
    event.preventDefault() if event?
    console.log('would delete', @props.file)

  render: ->
    SafetyButton @extendProps
      defaultButton:
        Link
          key: 'default'
          style: HoverOpacityStyle
          Icon(glyph: 'trash-o')
      abortButton:
        Link
          key: 'abort'
          style: HoverOpacityStyle
          Icon(glyph: 'ban')
      confirmButton:
        Link
          key: 'confirm'
          onClick: @deleteFile
          style: HoverOpacityStyle.merge
            color: 'red'
            marginRight: '0.5em'
          Icon(glyph: 'trash-o')



HoverOpacityStyle = new Style
  opacity: 0.2
  ':hover':
    opacity: 0.76
    color:' purple'
  ':focus':
    opacity: 1
    color:' orange'





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

