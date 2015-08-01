component 'DeleteFileLink',

  contextTypes:
    parentDirectory: React.PropTypes.object

  propTypes:
    file: React.PropTypes.object.isRequired

  onDelete: ->
    App.putio.files.delete(@props.file.id).then =>
      @context.parentDirectory && @context.parentDirectory.reload()

  render: ->
    DOM.DeleteLink
      className: 'DeleteFileLink'
      onDelete: @onDelete
      question: =>
        "Are you sure you want to delete #{@props.file.name}?"
