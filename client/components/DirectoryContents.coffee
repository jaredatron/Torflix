require 'stdlibjs/Array#first'

component = require 'reactatron/component'

Rows  = require 'reactatron/Rows'
Block = require 'reactatron/Block'

LoadFileMixin = require '../mixins/LoadFileMixin'
File = require './File'

module.exports = component 'DirectoryContents',

  mixins: [LoadFileMixin]

  defaultStyle:
    width: '100%'

  componentDidMount: ->
    file = @getFile()
    if file && file.isDirectory && !file.fileIds
      @app.pub 'load directory contents', file.id

  render: ->
    fileId = @getFileId()
    file = @getFile()
    loading = @get("files/#{fileId}/loading")

    if !file || !file.fileIds
      return if loading
        Block {}, 'Loading...'
      else
        Block {}, 'empty'

    files = file.fileIds.first(999).map (fileId) ->
      File key: fileId, fileId: fileId

    Rows @cloneProps(), files



