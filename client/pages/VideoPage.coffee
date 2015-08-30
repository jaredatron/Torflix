component = require 'reactatron/component'
Layer = require 'reactatron/Layer'
Layout = require '../components/Layout'
VideoPlayer = require '../components/VideoPlayer'

module.exports = component 'VideoPage',

  dataBindings: (props) ->
    file:    "files/#{props.fileId}"
    loading: "files/#{props.fileId}/loading"

  render: ->
    if @state.file
      Layer {},
        VideoPlayer file: @state.file
    else
      Layout null, 'loading...'
