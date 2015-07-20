#= require 'ReactPromptMixin'

SORTERS =

  created_at: (a, b) ->
    a = Date.parse(a.created_at)
    b = Date.parse(b.created_at)
    if a < b then 1 else if a > b then -1 else 0

  name: (a, b) ->
    a = a.name.toLowerCase()
    b = b.name.toLowerCase()
    if a < b then -1 else if a > b then 1 else 0

  size: (a, b) ->
    a = a.size
    b = b.size
    if a < b then 1 else if a > b then -1 else 0


# TODO dry up this duplicate
isDirectory = (file) ->
  file.content_type == "application/x-directory"


component 'DirectoryContents',

  mixins: [DepthMixin]

  propTypes:
    directory_id: React.PropTypes.number.isRequired
    sortBy:       React.PropTypes.any

  childContextTypes:
    parentDirectory: React.PropTypes.object

  getDefaultProps: ->
    sortBy: 'name'

  getChildContext: ->
    parentDirectory: this

  reload: ->
    App.putio.files.uncache(@props.directory_id)
    @forceUpdate()

  render: ->
    PromiseStateMachine
      promise: App.putio.files.list(@props.directory_id)
      loading: => DOM.div(style: @depthStyle(), 'loading...')
      loaded: @renderFiles

  renderFiles: (files) ->
    sorter = @props.sortBy
    sorter = SORTERS[sorter] if typeof sorter == 'string'

    DOM.div className: 'DirectoryContents',
      switch
        when null
          'NOT FOUND'
        when files.length > 0
          files.sort(sorter).map(@renderFile)
        else
          DOM.div(className: 'empty', style: @depthStyle(), 'empty')

  renderFile: (file) ->
    switch
      when file == null
        DOM.div(null, 'Error: File not found')
      when isDirectory(file)
        DOM.Directory(key: file.id, directory: file)
      else
        DOM.File(key: file.id, file: file)
