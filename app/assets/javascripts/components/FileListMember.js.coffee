#= require 'mixins/DepthMixin'

component 'FileListMember',

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
        DOM.DeleteFileLink(file_id: @props.file.id)

ChromecastLink = component
  displayName: 'FileList-ChromecastLink',
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



