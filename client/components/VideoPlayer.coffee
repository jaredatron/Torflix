$ = require 'jquery'
React = require 'react'
component = require 'reactatron/component'
{div, video, source} = require 'reactatron/DOM'

VideoJS = require '../vendor/video'


module.exports = component 'VideoPlayer',

  propTypes:
    file: component.PropTypes.object.isRequired

  componentDidMount: ->
    node = @getDOMNode()
    $(node).on('dblclick', @onDblclick)
    $(node.ownerDocument).on('keydown', @onKeydown)
    @initializePlayer()

  componentWillUnmount: ->
    node = @getDOMNode()
    $(node).off('dblclick', @onDblclick)
    $(node.ownerDocument).off('keydown', @onKeydown)

  initializePlayer: ->
    videoNode = @getDOMNode().getElementsByTagName('video')[0]
    component = this
    videojs videoNode, {}, ->
      component.player = new Player(this)
      window.DEBUG_PLAYER = component.player
      this.play()

  onDblclick: (event) ->
    event.preventDefault()
    @player.toggleFullscreen()

  onKeydown: (event) ->
    console.log('keydown', event)
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
    console.dir(@props.file)
    div dangerouslySetInnerHTML: {__html: @renderHTML()}


  renderHTML: ->
    file = @props.file
    React.renderToStaticMarkup video
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
      source
        src: "https://put.io/v2/files/#{file.id}/stream"
        type: file.content_type
      source
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


class Player
  constructor: (player) ->
    @player = player

  volumeUp: ->
    @volume 0.1

  volumeDown: ->
    @volume -0.1

  volume: (delta) ->
    volume = @player.volume()
    volume = volume + delta
    volume = 1 if volume > 1
    volume = 0 if volume < 0
    @player.volume(volume)

  pauseOrPlay: ->
    if @player.paused()
      @player.play()
    else
      @player.pause()

  requestFullscreen: ->


  toggleFullscreen: ->
    if @player.isFullscreen()
      @player.exitFullscreen()
    else
      @player.requestFullscreen()

  SKIP_LENGTH: 10

  skipLength: (large=false) ->
    if large then @SKIP_LENGTH * 2 else @SKIP_LENGTH

  currentTime: (delta) ->
    @player.currentTime @player.currentTime() + delta

  skipForward: (large) ->
    @currentTime(@skipLength(large))

  skipBackward: (large=false) ->
    @currentTime(@skipLength(large) * -1)

  ASPECT_RATIO_RANGE: [0.8, 1.4]
  toggleAspectRatio: ->
    @aspect_ratio ||= 1
    @aspect_ratio += 0.1
    @aspect_ratio = @ASPECT_RATIO_RANGE[0] if @aspect_ratio > @ASPECT_RATIO_RANGE[1]
    $(@player.tag).css("-webkit-transform","scaleY(#{@aspect_ratio})")



