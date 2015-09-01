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




IconLink = require './IconLink'

module.exports = component 'Directory',

  propTypes:
    file: component.PropTypes.object.isRequired

  childContextTypes:
    toggleDirectory: component.PropTypes.func

  getChildContext: ->
    toggleDirectory: @toggleDirectory

  toggleDirectory: (file) ->
    @app.onNext "store:change:files/#{file.id}", @rerender
    @app.pub 'toggle directory', file.id

  isLoading: ->
    {file} = @props
    !file || file.loading || file.needsLoading

  isEmpty: ->
    @props.file.fileIds.length == 0

  renderFile: (file) ->
    File key: file.id, file: file, toggleDirectory: @toggleDirectory

  render: ->

    {file} = @props

    if @isLoading()
      return Block @cloneProps(), 'Loading...'

    if @isEmpty()
      return Block @cloneProps(), 'empty'


    files = flattenFilesTree(@app, @props.file)

    Rows @cloneProps(), files.map(@renderFile)



React = require 'reactatron/React'
Style = require 'reactatron/Style'
withSyle = (style, element) ->
  React.cloneElement element,
    style: Style(element.props.style).extend(style)



File = component 'File',

  shouldComponentUpdate: (nextProps, nextState) ->
    a = @props.file
    b = nextProps.file
    return false if (
      a.id           == b.id            &&
      a.open         == b.open          &&
      b.loading      == b.loading       &&
      b.needsLoading == b.needsLoading
    )
    @app.stats.fileRerenders++
    true

  render: ->
    {file} = @props
    props = @extendProps
      style:
        marginLeft: "#{file.depth}em"
    FileRow props,

      Block style:{ flexShrink: 1, overflow:'hidden', },
        FileLink file: file, style:{ overflow:'hidden', width: '100%', textOverflow: 'ellipsis'}

      RemainingSpace style:{ marginLeft: '1em'}

      withSyle flexBasis: '20px',
        DownloadFileLink file: file, tabIndex: -1

      withSyle flexBasis: '20px',
        LinkToFileOnPutio file: file, tabIndex: -1

      withSyle flexBasis: '30px',
        FileSize size: file.size, tabIndex: -1
      # Space(2)
      # DeleteFileButton file: file, tabIndex: -1



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












flattenFilesTree = (app, file, depth=0) ->
  files = []
  if file.isDirectory
    file.fileIds?.forEach (fileId) ->
      file = app.get("files/#{fileId}") || {}
      file.depth = depth
      files.push file
      if file.open
        files.push flattenFilesTree(app, file, depth+1)...
  files

