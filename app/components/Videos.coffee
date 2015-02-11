React = require 'react'
component = require '../component'
PromiseStateMachine = require './PromiseStateMachine'
LinkToVideoPlayerModal = require './LinkToVideoPlayerModal'

{div, span, img} = React.DOM

module.exports = component 'Videos',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  render: ->
    PromiseStateMachine
      promise: @context.putio.files.search('type:video')
      loaded: @renderVideos

  renderVideos: (response) ->
    videos = response.files
    div
      className: 'Videos flex-row flex-row-wrap',

      videos.map (video) ->
        Video(key: video.id, video: video)






Video = component 'Video',

  propTypes:
    video: React.PropTypes.object.isRequired

  fileName: ->
    @props.video.name.replace(/\./g,' ')

  render: ->
    div
      className: 'Videos-Video'
      LinkToVideoPlayerModal
        file_id: @props.video.id
        div
          className: 'Videos-Video-screenshot'
          img
            src: @props.video.screenshot
        div(null, @fileName())
