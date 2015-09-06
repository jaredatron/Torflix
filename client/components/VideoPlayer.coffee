React = require 'reactatron/React'
component = require 'reactatron/component'
VideoPlayer = require '../VideoPlayer'

module.exports = component 'VideoPlayer',

  propTypes:
    file: component.PropTypes.object.isRequired

  shouldComponentUpdate: -> false

  componentWillReceiveProps: ({file}) ->
    debugger

  componentDidMount: ->
    node = @getDOMNode()
    node.addEventListener('dblclick', @onDblclick)
    node.ownerDocument.addEventListener('keydown', @onKeydown)
    @setupPlayer()

  componentDidUpdate: ->
    @setupPlayer()

  componentWillUnmount: ->
    @player.saveCurrentTime()
    node = @getDOMNode()
    node.removeEventListener('dblclick', @onDblclick)
    node.ownerDocument.removeEventListener('keydown', @onKeydown)

  setupPlayer: ->
    @player = new VideoPlayer
      app:     @app
      DOMNode: @getDOMNode().getElementsByTagName('video')[0]
      noError: => @forceUpdate()
    console.log('setupPlayer', @player)



  onDblclick: (event) ->
    event.preventDefault()
    @player.toggleFullscreen()

  onKeydown: (event) ->
    switch event.keyCode
      when 32 # space
        @player.pauseOrPlay()
      when 187 # +
        @player.volumeUp()
      when 189 # -
        @player.volumeDown()
      when 38  # up arrow
        @player.volumeUp()
      when 40  # down arrow
        @player.volumeDown()
      when 39 # right arrow
        @player.skipForward(event.shiftKey)
      when 37 # left arrow
        @player.skipBackward(event.shiftKey)
      when 70 # f
        @player.toggleFullscreen()
      when 65 # a
        @player.toggleAspectRatio()


  render: ->
    console.info('VideoPlayer render')
    React.createElement 'div', dangerouslySetInnerHTML: {__html: videoHTML(@props.file)}


videoHTML = (file) ->
  React.renderToStaticMarkup React.createElement 'video',
    className: "video-js vjs-default-skin"
    controls: true
    preload: 'auto'
    loop: false
    poster: file.screenshot
    height: '100%'
    width: '100%'
    style:
      position: 'fixed'
      height: '100%'
      width: '100%'
    React.createElement 'source',
      src: "https://put.io/v2/files/#{file.id}/stream"
      type: file.content_type
    React.createElement 'source',
      src: "https://put.io/v2/files/#{file.id}/mp4/stream"
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
