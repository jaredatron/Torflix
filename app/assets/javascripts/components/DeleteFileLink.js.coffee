component 'DeleteFileLink',

  contextTypes:
    parentDirectory: React.PropTypes.object

  propTypes:
    file: React.PropTypes.object.isRequired

  onDelete: ->
    putio.files.delete(@props.file.id).complete =>
      if @context.parentDirectory
        @context.parentDirectory.reload()

  render: ->
    DOM.DeleteLink
      className: 'DeleteFileLink'
      onDelete: @onDelete
      question: =>
        "Are you sure you want to delete #{@props.file.name}?"
