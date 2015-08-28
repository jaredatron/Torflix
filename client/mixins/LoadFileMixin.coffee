module.exports = LoadFileMixin =

  getFileId: ->
    if @props.fileId? then @props.fileId else @props.file.id

  getFile: ->
    @get "files/#{@getFileId()}"

  loadFile: ->
    @app.pub 'load file', @getFileId()

  setFile: (file) ->
    @app.set "files/#{@getFileId()}": file

  componentDidMount: ->
    @loadFile() unless @getFile()


