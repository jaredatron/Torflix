component = require 'reactatron/component'
Layout = require '../components/Layout'
Rows = require 'reactatron/Rows'
Block = require 'reactatron/Block'
VideoPlayer = require '../components/VideoPlayer'

module.exports = component 'VideoPage',

  dataBindings: ->
    file:    "files/#{@props.fileId}"
    loading: "files/#{@props.fileId}/loading"

  render: ->
    if @state.file
      VideoPlayer file: @state.file
    else
      Layout null, 'loading...'
  #   DOM.div
  #     className: 'VideoPage'

  #     PromiseStateMachine
  #       promise: App.putio.files.get(Location.params.file_id)
  #       loading: =>
  #         DOM.div(null, 'loading...')
  #       loaded: @renderLoaded


  # renderLoaded: (file) ->


  #   div
  #     className: 'flex-column flex-grow'

  #     h4 null, file.name

  #     VideoPlayer(className: 'flex-grow', file: file)

  #     div
  #       className: 'flex-row flex-space-around'
  #       ExternalLink href: file.put_io_url,     'put.io'
  #       DownloadLink href: file.download_url,   'download'
  #       ExternalLink href: file.stream_url,     'stream'
  #       ExternalLink href: file.playlist_url,   'playlist'
  #       ExternalLink href: file.chromecast_url, 'chromecast'
