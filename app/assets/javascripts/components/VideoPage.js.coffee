#= require 'ReactPromptMixin'

component 'VideoPage',

  contextTypes:
    params: React.PropTypes.object.isRequired

  render: ->
    DOM.div
      className: 'VideoPage'

      PromiseStateMachine
        promise: App.putio.files.get(@context.params.file_id)
        loading: =>
          DOM.div(null, 'loading...')
        loaded: @renderLoaded


  renderLoaded: (file) ->
    {div, h4, VideoPlayer, ExternalLink, DownloadLink} = DOM

    div
      className: 'flex-column flex-grow'

      h4 null, file.name

      VideoPlayer(className: 'flex-grow', file: file)

      div
        className: 'flex-row flex-space-around'
        ExternalLink href: file.put_io_url,     'put.io'
        DownloadLink href: file.download_url,   'download'
        ExternalLink href: file.stream_url,     'stream'
        ExternalLink href: file.playlist_url,   'playlist'
        ExternalLink href: file.chromecast_url, 'chromecast'
