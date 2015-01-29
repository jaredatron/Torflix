React      = require 'react'
component  = require '../component'

{div, span, a} = React.DOM

module.exports = component 'VideoPlayer',

  propTypes:
    file: React.PropTypes.object.isRequired

  getInitialState: ->
    htmlId: 'VideoPlayer'+Date.now()

  render: ->
    div id: @state.htmlId, className: 'VideoPlayer'

  componentDidMount: ->
    console.log(@props.file.name)
    console.log(@props.file)
    initializeJwplayer(@state.htmlId)





initializeJwplayer = (id) ->

  if typeof jwplayer != 'function'
    console.log('waiting for jwplayer')
    return setTimeout((-> initializeJwplayer(id)), 100)

  console.log('initing video player')

  jwplayer.key = "0WD/covVP7M8mqlQePjQuXXbosftztFp4PIMAQ=="

  player = jwplayer(id).setup({
      file: "https://put.io/v2/files/271827519/stream?token=83ec7778fbd711e39c51001018321b64",
      image: "https://put.io/screenshots/lFxnYJNgZFuSV1xnXmuOkWleWGVbh2demV1mZ5NblIpbk4mWX2lgkA%3D%3D.jpg",
      width: '100%',
      height: '100%',
      type: "mp4",
      startparam: "start",
      primary: "flash",
      tracks: [{
              file: "",
              label: "",
              kind: "subtitles",
              default: true
      }],
      captions: {
          back: false,
          fontsize: 20
      },
      logo: {
          hide: true
      }
  });
  window.DEBUG = player
