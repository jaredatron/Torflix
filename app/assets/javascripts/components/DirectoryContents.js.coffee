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


component 'DirectoryContents',

  mixins: [DepthMixin]

  propTypes:
    directory_id: React.PropTypes.number.isRequired
    sortBy:       React.PropTypes.oneOfType([
                    React.PropTypes.string,
                    React.PropTypes.fun,
                  ]).isRequired
    sortOrder:    React.PropTypes.oneOf(['asc','desc'])

  childContextTypes:
    parentDirectory: React.PropTypes.object

  getDefaultProps: ->
    sortBy: 'name'
    sortOrder: 'asc'

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
    console.log('DIREC CON RERENDER', @props, @state)
    sorter = @props.sortBy
    sorter = SORTERS[sorter] if typeof sorter == 'string'

    files = files.sort(sorter)
    files = files.reverse() if @props.sortOrder == 'desc'

    DOM.div className: 'DirectoryContents',
      switch
        when null
          'NOT FOUND'
        when files.length > 0
          files.map(@renderFile)
        else
          DOM.div(className: 'empty', style: @depthStyle(), 'empty')

  renderFile: (file) ->
    switch
      when file == null
        DOM.div(null, 'Error: File not found')
      when file.isDirectory
        DOM.Directory(key: file.id, directory: file)
      else
        DOM.File(key: file.id, file: file)
