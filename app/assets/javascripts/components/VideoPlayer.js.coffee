#= require 'ReactPromptMixin'

component 'VideoPlayer',

  propTypes:
    file: React.PropTypes.object.isRequired

  componentDidMount: ->
    videoNode = @refs.video.getDOMNode()
    videojs videoNode, {}, ->
      console.log('video inititialized')

  render: ->
    file = @props.file

    console.dir(file)

    {div, h1, ExternalLink, DownloadLink, img, video, source, track} = DOM

    div null,
      h1 null, file.name
      div
        className: 'flex-column'
        ExternalLink href: file.put_io_url,     'put.io'
        DownloadLink href: file.download_url,   'download'
        ExternalLink href: file.stream_url,     'stream'
        ExternalLink href: file.playlist_url,   'playlist'
        ExternalLink href: file.chromecast_url, 'chromecast'


      video
        ref: 'video'
        className: "video-js vjs-default-skin"
        controls: true
        preload: "none"
        width: 640
        height: 264
        poster: file.screenshot
        source
          src: file.stream_url
          type: file.content_type
        source
          src: file.mp4_stream_url
          type: 'video/mp4'
        # track
        #   kind: "captions"
        #   src: "demo.captions.vtt"
        #   srclang: "en"
        #   label: "English"
        # track
        #   kind: "subtitles"
        #   src: "demo.captions.vtt"
        #   srclang: "en"
        #   label: "English"

      JSON.stringify(file)
