VideoJS = require './vendor/video'

module.exports = class VideoPlayer
  constructor: ({@app, @config, DOMNode}) ->
    Object.bindAll(this)
    @config ||= {}
    player = this
    videojs(DOMNode, @config, -> player.ready(this))

    #DEBUGGG
    global.player = this

  ready: (player) ->
    @player = player
    @player.on 'timeupdate', @saveCurrentTime

    @player.currentTime @app.get("VideoPlayer/#{@player.currentSrc()}") || 0
    @player.play()

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

  toggleFullscreen: ->
    if @player.isFullscreen()
      @player.exitFullscreen()
    else
      @player.requestFullscreen()

  SKIP_LENGTH: 10

  skipLength: (large=false) ->
    if large then @SKIP_LENGTH * 2 else @SKIP_LENGTH

  skipForward: (large) ->
    @player.currentTime @player.currentTime() + @skipLength(large)

  skipBackward: (large=false) ->
    @player.currentTime @player.currentTime() - @skipLength(large)

  ASPECT_RATIO_RANGE: [0.8, 1.4]
  toggleAspectRatio: ->
    @aspect_ratio ||= 1
    @aspect_ratio += 0.1
    @aspect_ratio = @ASPECT_RATIO_RANGE[0] if @aspect_ratio > @ASPECT_RATIO_RANGE[1]
    $(@player.tag).css("-webkit-transform","scaleY(#{@aspect_ratio})")

  saveCurrentTime: ->
    @app.set "VideoPlayer/#{@player.currentSrc()}": @player.currentTime()





