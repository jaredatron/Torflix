#= require 'ReactPromptMixin'

component 'VideoPlayer',

  propTypes:
    file: React.PropTypes.object.isRequired

  componentDidMount: ->
    videoNode = @getDOMNode().getElementsByTagName('video')[0]
    videojs videoNode, {}, ->
      player = this
      window.VIDEO_PLAYER = player
      console.info('video inititialized')
      console.info('window.VIDEO_PLAYER = ', this)
      player.play()
      # player.currentTime(120)

  render: ->
    console.dir(@props.file)
    DOM.div
      className: Classnames('VideoPlayer', @props.className)
      dangerouslySetInnerHTML: {__html: @renderHTML()}


  renderHTML: ->
    {video, source} = DOM
    file = @props.file
    React.renderToStaticMarkup video
      className: "video-js vjs-default-skin"
      controls: true
      preload: "none"
      poster: file.screenshot
      height: 'auto'
      width: '100%'
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
