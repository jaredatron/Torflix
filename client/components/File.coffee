require 'stdlibjs/Array#first'

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

File = component 'File',

  # mixins: [LoadFileMixin]

  propTypes:
    fileId: component.PropTypes.number.isRequired

  dataBindings: ->
    file: "files/#{@props.fileId}"

  render: ->
    file = @state.file

    if !file
      return Block @cloneProps(), ':S ????'

    if file.loading
      return Block @cloneProps(), 'Loading...'


    if file.isDirectory && file.open
      directoryContents = DirectoryContents
        fileId: file.id
        style:
            marginLeft: '1em'

    Rows @cloneProps(),
      FileRow file: file, open: open
      directoryContents


DirectoryContents = component 'DirectoryContents',

  # mixins: [LoadFileMixin]

  propTypes:
    fileId: component.PropTypes.number.isRequired

  dataBindings: ->
    file: "files/#{@props.fileId}"

  componentDidMount: ->
    file = @state.file
    if !file || file.needsLoading
      @app.pub 'load file', @props.fileId

  render: ->
    fileId = @props.fileId
    file = @state.file
    loading = @state.loading

    if !file || file.loading
      return Block @cloneProps(), 'Loading...'

    if file.fileIds && file.fileIds.length == 0
      return Block @cloneProps(), 'empty'

    files = file.fileIds.map (fileId) ->
      File key: fileId, fileId: fileId

    Rows @cloneProps(), files






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



FileRow = component 'FileRow',

  mixins: [ActiveMixin]

  propTypes:
    file: component.PropTypes.object.isRequired

  defaultStyle:
    whiteSpace: 'nowrap'
    padding: '0.25em 0.5em'
    ':hover':
      backgroundColor: '#DFEBFF'
    ':active':
      backgroundColor: '#DFEBFF'

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
    props.style.marginLeft = "#{file.depth}em"
    if @state.active
      props.style.update props.style[':active']
    Columns props,
      Filelink
        file: file,
        open: file.open
        onClick: @onClick
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
      DeleteFileLink file: file, tabIndex: -1


  Link onClick: (-> ), Icon(glyph:'download')



Filelink = (props) ->
  switch
    when props.file.isVideo
      PlayVideoLink(props)
    when props.file.isDirectory
      DirectoryToggleLink(props)
    else
      DownloadFileLink(props, props.file.name)



IconLink = component (props) ->
  props.style.update
    # flexGrow: 1
    flexShrink: 10
    # overflow: 'hidden'
    # textOverflow: 'ellipsis'

  icon = Icon
    glyph: props.glyph,
    fixedWidth: true,
    style:
      marginRight: '0.5em'

  props.children ||= []
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


DeleteFileLink = component 'DeleteFileLink',
  defaultStyle:
    opacity: 0.2
    ':hover':
      opacity: 1
      color: 'blue'
  onClick: (event) ->
    event.preventDefault()
    console.log('would delete', @props.file)
  render: ->
    Link @extendProps(onClick: @onClick),
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

