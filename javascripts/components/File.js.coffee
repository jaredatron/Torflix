#= require 'mixins/DepthMixin'

component 'File',

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
        className: 'File-newIcon',
        DOM.Glyphicon(glyph:'asterisk')

  size: ->
    DOM.div
      className: 'File-size',
      DOM.FileSize(size: @props.file.size)

  name: ->
    if @isVideo()
      PlayVideoLink(
        className: 'File-name flex-spacer'
        file: @props.file
      )
    else
      DOM.div(className: 'File-name flex-spacer',
        DOM.Glyphicon(glyph:'file', className: 'File-icon'),
        DOM.span(null, @props.file.name),
      )

  render: ->
    {div} = DOM
    div className: 'File',
      div className: 'File-row flex-row',
        div(style: @depthStyle())
        @name()
        @newIcon()
        DownloadLink(file_id: @props.file.id, DOM.Glyphicon(glyph:'download'))
        PutioLink(file: @props.file)
        ChromecastLink(file_id: @props.file.id)
        @size()
        DOM.DeleteFileLink(file: @props.file)

ChromecastLink = component
  displayName: 'File-ChromecastLink',
  render: ->
    DOM.ExternalLink
      href: "https://put.io/file/#{@props.file_id}/chromecast?subtitle=off"
      className: 'File-ChromecastLink',
      title: 'chromecast',
      DOM.Glyphicon glyph: 'new-window'

PutioLink = component
  displayName: 'File-PutioLink',
  render: ->
    DOM.ExternalLink
      href: "https://put.io/file/#{@props.file_id}"
      className: 'File-PutioLink',
      title: 'put.io',
      DOM.Glyphicon glyph: 'new-window'

DownloadLink = component
  displayName: 'File-DownloadLink',
  propTypes:
    file_id: React.PropTypes.number.isRequired
  render: ->
    props = Object.assign({}, @props)
    props.href = "https://put.io/v2/files/#{@props.file_id}/download"
    props.className = 'File-DownloadLink'
    DOM.DownloadLink(props)



PlayVideoLink = component
  displayName: 'File-PlayVideoLink',
  propTypes:
    file: React.PropTypes.object.isRequired
  render: ->
    DOM.LinkToPlayVideo(
      className: @props.className,
      file_id: @props.file.id,
      DOM.Glyphicon(glyph:'facetime-video', className: 'File-icon'),
      @props.file.name,
    )



