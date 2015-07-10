#= require 'ReactPromptMixin'

component 'VideoPlayer',

  propTypes:
    file: React.PropTypes.object.isRequired

  render: ->
    file = @props.file

    # type = file.name.match(/\.([^.]+)$/)[1];
    if file.is_mp4_available
      src = "https://put.io/v2/files/#{file.id}/mp4/stream"
    else
      src = "https://put.io/v2/files/#{file.id}/stream"

    DOM.iframe className: 'VideoPlayer', src: src
