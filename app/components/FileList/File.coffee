React = require 'react'
component = require '../../component'
DepthMixin = require './DepthMixin'
LinkToVideoPlayerModal = require '../LinkToVideoPlayerModal'
DownloadLink = require '../DownloadLink'
Glyphicon = require 'react-bootstrap/Glyphicon'

{div, span, a} = React.DOM

module.exports = component 'FileList-File',

  mixins: [DepthMixin]

  propTypes:
    file: React.PropTypes.object.isRequired

  isVideo: ->
    /\.(mkv|mp4|avi)$/.test @props.file.name

  render: ->
    name = span(null, @props.file.name)

    div
      className: 'FileList-File',
      if @isVideo()
        LinkToVideoPlayerModal
          style: { paddingLeft: "#{@depth()}em" }
          className: 'FileList-File-name'
          file_id: @props.file.id
          Glyphicon(glyph:'facetime-video', className: 'FileList-File-icon')
          name
      else
        DownloadLink
          style: { paddingLeft: "#{@depth()}em" }
          href: "https://put.io/v2/files/#{@props.file.id}/download"
          className: 'FileList-File-name'
          Glyphicon(glyph:'file', className: 'FileList-File-icon')
          name

