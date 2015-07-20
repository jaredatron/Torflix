isDirectory = (file) ->
  file.content_type == "application/x-directory"

component 'TransferFile',

  propTypes:
    file_id: React.PropTypes.number.isRequired

  getInitialState: ->
    loading: true
    error: null

  render: ->
    PromiseStateMachine
      promise: App.putio.files.get(@props.file_id)
      loaded: @renderFile

  renderFile: (file) ->
    DOM.div className: 'TransferFile',
      switch
        when file == null
          DOM.div(null, 'Error: File not found')
        when isDirectory(file)
          DOM.DirectoryContents(directory_id: @props.file_id)
        else
          DOM.File(file: file)


