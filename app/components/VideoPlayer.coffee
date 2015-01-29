React      = require 'react'
component  = require '../component'

{div, span, a, video, source, iframe} = React.DOM

module.exports = component 'VideoPlayer',

  propTypes:
    file: React.PropTypes.object.isRequired

  getInitialState: ->
    htmlId: 'VideoPlayer'+Date.now()

  render: ->
    # div id: @state.htmlId, className: 'VideoPlayer'

    file = @props.file
    console.dir(file)

    # type = file.name.match(/\.([^.]+)$/)[1];
    if file.is_mp4_available
      src = "https://put.io/v2/files/#{file.id}/mp4/stream"
    else
      src = "https://put.io/v2/files/#{file.id}/stream"

    iframe className: 'VideoPlayer', src: src


    # video
    #   controls: true
    #   source
    #     src: "https://s10.put.io/download/271969459?token=83ec7778fbd711e39c51001018321b64&u=mJmonWpfXJlhVWBnWmRdX5SSnGFWXl9VY15maFxdYlpVYFZqZWdiYllnVlSWjpg%3D"
    #     # src: "https://put.io/v2/files/#{@props.file.id}/stream"
    #         # "https://put.io/v2/files/271969459/stream?token=83ec7778fbd711e39c51001018321b64"
    #     type: "video/#{type}"

  # componentDidMount: ->
    # console.log(@props.file.name)
    # console.log(@props.file)
    # initializeJwplayer(@state.htmlId, @props.file)





# initializeJwplayer = (id, file) ->

#   # if typeof jwplayer != 'function'
#   #   console.log('waiting for jwplayer')
#   #   return setTimeout((-> initializeJwplayer(id)), 100)

#   console.log('initing video player')

#   jwplayer.key = "0WD/covVP7M8mqlQePjQuXXbosftztFp4PIMAQ=="

#   debugger

#   type = file.name.match(/\.([^.]+)$/)[1];

#   player = jwplayer(id).setup({
#       file: "https://put.io/v2/files/271969459/stream?token=83ec7778fbd711e39c51001018321b64",
#       image: "https://put.io/screenshots/Z1tnk2WRkl9pioqTXpVgYmRkh2WJWJJVmmFglWNWaIheYFlkX5WUZA%3D%3D.jpg",
#       # file: "https://put.io/v2/files/271827519/stream?token=83ec7778fbd711e39c51001018321b64",
#       image: file.screenshot,
#       width: '100%',
#       height: '100%',
#       type: type,
#       startparam: "start",
#       primary: "flash",
#       tracks: [],
#       captions: {
#           back: false,
#           fontsize: 20
#       },
#       logo: {
#           hide: true
#       }
#   });

#   window.DEBUG_PLAYER = player
