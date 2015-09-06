component = require 'reactatron/component'
Block = require 'reactatron/Block'
Rows = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
Space = require 'reactatron/Space'
RemainingSpace = require 'reactatron/RemainingSpace'
Layout = require '../components/Layout'
Directory = require '../components/Directory'
Button = require '../components/Button'
ButtonLink = require '../components/ButtonLink'
Icon = require '../components/Icon'
Image = require '../components/Image'

module.exports = component 'FilesPage',

  propTypes:
    fileId: component.PropTypes.string

  getFileId: ->

  dataBindings: (props) ->
    file: "files/#{props.fileId || 0}"

  componentDidMount: ->
    fileId = @props.fileId || 0
    @reset(fileId)
    @focusFirstFile()

  componentWillReceiveProps: (nextProps) ->
    nextFileId = nextProps.fileId || 0
    @reset(nextFileId) if @props.fileId != nextFileId

  reset: (fileId) ->
    @app.pub('load directory', fileId)

  componentDidUpdate: ->
    @focusFirstFile()

  focusFirstFile: ->
    @getDOMNode().querySelector('a.Directory-FileLink')?.focus()

  render: ->
    fileId = @props.fileId || 0
    file = @state.file || {id: fileId}



    switch
      when !file.loaded
        title = 'Loading...'
      when file.notFound
        title = 'File Not Found'
        button = ButtonLink path: '/files', 'back'
      when file.isDirectory
        title = file.name
        content = Directory file: file
        button = ReloadButton file: file
      else
        title = file.name
        content = File file: file
        button = ReloadButton file: file


    Layout {},
      Rows style: {overflowY: 'scroll'}, onKeyDown: @onKeyDown,
        Columns
          style:
            padding:'0.5em'
            marginBottom: '0.75em'
            alignItems: 'center'
          Header {}, title
          RemainingSpace {}
          button
        content




Header = Block.withStyle 'Header',
  fontSize: '150%'



ReloadButton = component 'ReloadButton', (props) ->
  props.onClick = =>
    @app.pub 'reload file', props.file.id

  Button props, 'reload'




File = component 'File',
  render: ->
    file = @props.file

    if file.isVideo
      Rows @extendProps({style:{alignItems: 'center'}}),
        Block {},
          ButtonLink path: "/video/#{file.id}", 'play'
          Space()
          ButtonLink href: "https://put.io/v2/files/#{file.id}/download", 'download'
          Space()
          ButtonLink href: "https://put.io/v2/files/#{file.id}/stream", 'stream'
          Space()
          if file.is_mp4_available
            ButtonLink href: "https://put.io/v2/files/#{file.id}/mp4/stream", 'stream mp4'
          # else
          #   ButtonLink {}, 'convert to mp4'
          Space()
          ButtonLink href: "https://put.io/file/#{file.id}", 'Put.io'

        Block {}, Space()

        Image src: file.screenshot
    else
      Rows @cloneProps(),
        Object.keys(file).sort().map (key) ->
          Columns key:key,
            Block {style:{flexBasis:'200px'}}, key
            Block {}, JSON.stringify(file[key])

