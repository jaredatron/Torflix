#= require 'ReactPromptMixin'

component 'VideoPlayer',

  propTypes:
    file: React.PropTypes.object.isRequired

  componentDidMount: ->
    videoNode = @getDOMNode().getElementsByTagName('video')[0]
    videojs videoNode, {}, ->
      console.log('video inititialized', this)

  render: ->
    console.dir(@props.file)
    DOM.div dangerouslySetInnerHTML: {__html: @renderHTML()}


  renderHTML: ->
    {video, source} = DOM
    file = @props.file
    React.renderToStaticMarkup video
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
