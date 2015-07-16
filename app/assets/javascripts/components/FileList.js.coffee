#= require 'PromiseStateMachine'
#= require 'mixins/DepthMixin'

isDirectory = (file) ->
  file.content_type == "application/x-directory"

component 'FileList',

  propTypes:
    file_id: React.PropTypes.number.isRequired

  getInitialState: ->
    loading: true
    error: null

  render: ->
    PromiseStateMachine
      promise: putio.files.get(@props.file_id)
      loaded: @renderFile

  renderFile: (file) ->
    DOM.div className: 'FileList',
      if isDirectory(file)
        DOM.DirectoryContents(directory_id: @props.file_id)
      else
        DOM.FileListMember(file: file)


