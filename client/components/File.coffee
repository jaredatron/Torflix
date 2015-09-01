require 'stdlibjs/Array#first'
toArray = require 'stdlibjs/toArray'

component = require 'reactatron/component'

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

File = component 'File',

  # mixins: [LoadFileMixin]

  propTypes:
    fileId: component.PropTypes.number.isRequired
    autoload: component.PropTypes.bool
    empty:    component.PropTypes.bool

  dataBindings: (props) ->
    file: "files/#{props.fileId}"

  componentDidMount: ->
    return unless @props.autoload
    @app.pub('load file', @props.fileId || 0)

  componentWillReceiveProps: (nextProps) ->
    return unless @props.autoload
    nextFileId = nextProps.fileId || 0
    @app.pub('load file', nextFileId) if @props.fileId != nextFileId

  shouldComponentUpdate: (nextProps, nextState) ->
    a = @state.file
    b = nextState.file
    x = (
      @props.empty != nextProps.empty ||
      a.open != b.open ||
      (a.needsLoading && !b.needsLoading)
    )
    @app.stats.fileRerenders++ if x


  render: ->
    file = @state.file

    if !file
      return Block @cloneProps(), ':S ????'

    if file.loading
      return Block @cloneProps(), 'Loading...'


    if file.isDirectory && file.open
      directoryContents = DirectoryContents
        file: file
        style:
            marginLeft: '1em'

    fileRow = if @props.empty
      EmptyFileRow()
    else
      FileRow file: file, open: file.open
    Rows @cloneProps(), fileRow, directoryContents


DirectoryContents = component 'DirectoryContents',

  # mixins: [LoadFileMixin]

  propTypes:
    file: component.PropTypes.object.isRequired

  getInitialState: ->
    max: 10

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

  renderFiles: ->
    @grow()
    max = @state.max
    @props.file.fileIds.map (fileId, index) ->
      File key: fileId, fileId: fileId, empty: (index+1>max)

  needsToGrow: ->
    !@isLoading() && @props.file.fileIds.length > @state.max

  render: ->
    {file} = @props

    if @isLoading()
      return Block @cloneProps(), 'Loading...'

    if @isEmpty()
      return Block @cloneProps(), 'empty'

    Rows @cloneProps(), @renderFiles()






ActiveMixin =
  getInitialState: ->
    active: false

  componentDidMount: ->
    node = @getDOMNode()
    node.addEventListener 'focusin', @activate
    node.addEventListener 'focusout', @deactivate
    # node.addEventListener 'mouseenter', @activate
    # node.addEventListener 'mouseleave', @deactivate

  componentWillUnmount: ->
    node = @getDOMNode()
    node.removeEventListener 'focusin', @activate
    node.removeEventListener 'focusout', @deactivate
    # node.removeEventListener 'mouseenter', @activate
    # node.removeEventListener 'mouseleave', @deactivate

  activate: ->
    @setState active: true

  deactivate: ->
    @setState active: false


EmptyFileRow = Columns.withStyle 'EmptyFileRow',
  minHeight: '24px'
  whiteSpace: 'nowrap'
  padding: '0.25em 0.5em'
  ':hover':
    backgroundColor: '#DFEBFF'
  ':active':
    backgroundColor: '#DFEBFF'



FileRow = component 'FileRow',

  mixins: [ActiveMixin]

  propTypes:
    file: component.PropTypes.object.isRequired

  onClick: (event) ->
    if @props.file.isDirectory
      event.preventDefault()
      if event.altKey
        @app.setLocation "/files/#{@props.file.id}"
      else
        @app.pub 'toggle directory', @props.file.id

  render: ->
    file = @props.file
    props = @cloneProps()
    props.extendStyle
      marginLeft: "#{file.depth}em"
    props.extendStyle(props.style[':active']) if @state.active

    EmptyFileRow props,
      Filelink
        file: file,
        open: file.open
        onClick: @
        style:
          overflow: 'hidden'
          textOverflow: 'ellipsis'

      RemainingSpace {}
      DownloadFileLink file: file, tabIndex: -1
      Space(2)
      LinkToFileOnPutio file: file, tabIndex: -1
      Space(2)
      FileSize size: file.size, style:{width: '4em'}, tabIndex: -1
      Space(2)
      DeleteFileButton file: file, tabIndex: -1


  # Link onClick: (-> ), Icon(glyph:'download')



Filelink = (props) ->
  switch
    when props.file.isVideo
      PlayVideoLink(props)
    when props.file.isDirectory
      DirectoryToggleLink(props)
    else
      DownloadFileLink(props, props.file.name)



IconLink = component (props) ->
  props.extendStyle
    # flexGrow: 1
    flexShrink: 10
    # overflow: 'hidden'
    # textOverflow: 'ellipsis'

  icon = Icon
    glyph: props.glyph,
    fixedWidth: true,
    style:
      marginRight: '0.5em'

  props.children = toArray(props.children)
  props.children.unshift icon

  Link(props)

LinkToFile = (props) ->
  props.path  ||= "/files/#{props.file.id}"
  props.glyph ||= 'file'
  IconLink(props, props.file.name)

LinkToFileOnPutio = (props) ->
  props.href = if props.file.isVideo
    "https://put.io/file/#{props.file.id}"
  else
    "https://put.io/your-files/#{props.file.id}"
  props.glyph ||= 'circle'
  props.title ||= 'open at put.io'
  IconLink(props)

PlayVideoLink = (props) ->
  props.path  ||= "/video/#{props.file.id}"
  props.glyph ||= 'play'
  IconLink props, props.file.name

DirectoryToggleLink = (props) ->
  props.glyph = props.open and 'chevron-down' or 'chevron-right'
  LinkToFile props

DownloadFileLink = (props, children...) ->
  props.glyph ||= 'download'
  props.title ||= 'download'
  props.href = "https://put.io/v2/files/#{props.file.id}/download"
  IconLink(props, children...)


DeleteFileButton = component 'DeleteFileButton',
  defaultStyle:
    opacity: 0.2
    ':hover':
      opacity: 1
    ':focus':
      opacity: 1
  deleteFile: (event) ->
    event.preventDefault() if event?
    console.log('would delete', @props.file)
  render: ->
    SafetyButton @extendProps
      defaultButton:
        Link {}, Icon(glyph: 'trash-o')
      abortButton:
        Link {}, Icon(glyph: 'ban')
      confirmButton:
        Link
          onClick: @deleteFile
          style:
            color: 'red'
            marginRight: '0.5em'
          Icon(glyph: 'trash-o')




File.DirectoryContents = DirectoryContents
module.exports = File





flattenFilesTree = (app, fileIds, depth=0) ->
  files = []
  fileIds and fileIds.forEach (fileId) ->
    file = app.get("files/#{fileId}") || {}
    file.depth = depth
    files.push file
    if file.open
      files.push flattenFilesTree(app, file.fileIds, depth+1)...
  files

