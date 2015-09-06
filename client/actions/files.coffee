require 'shouldhave/Array#without'
require 'shouldhave/Array#unique'


module.exports = (app) ->

  STREAM_AUTH_TOKEN = 'WE NEED TO GET THIS FROM THE API???'
  OAUTH_TOKEN = ''

  get = (id) ->
    app.get "files/#{id}"

  del = (id) ->
    set(id, undefined)

  set = (id, value) ->
    app.set "files/#{id}": value
    app.pub 'file changed', id: id, value: value

  update = (id, updates) ->
    original = get(id) || {id: id}
    file = Object.assign({}, original, updates)
    set(id, file)

  updateAfterLoading = (file) ->
    file.loading = false
    update(file.id, file)


  loadFile = (id, file) ->
    file ||= get(id)
    reloadFile(id, file) if !file?

  reloadFile = (id, file) ->
    file ||= get(id) || {id:id}
    file.loading = true
    set(id, file)
    if file.isDirectory || file.id == 0
      app.putio.directoryContents(id).then ({parent, files}) ->
        [parent].concat(files).forEach(updateAfterLoading)
    else
      app.putio.file(id).then(updateAfterLoading)

  deleteFile = (id, file) ->
    file ||= get(id)
    return if !file?
    file.beingDeleted = true
    set(id, file)
    app.putio.deleteFile(id).then ->
      removeFileFromDirectory(file)
      del(id)

  removeFileFromDirectory = (file) ->
    parent = get(file.parent_id)
    return unless parent && parent.fileIds
    parent.fileIds = parent.fileIds.without(file.id)
    set(file.parent_id, parent)

  openDirectory = (id, file) ->
    file ||= get(id)
    return unless file && file.isDirectory
    file.open = true
    set(id, file)
    reloadFile(id, file) unless file.directoryContentsLoaded

  closeDirectory = (id, file) ->
    file ||= get(id)
    return unless file && file.isDirectory
    file.open = false
    set(id, file)

  toggleDirectory = (id, file) ->
    file ||= get(id)
    return unless file && file.isDirectory
    if file.open
      closeDirectory(id, file)
    else
      openDirectory(id, file)

  # actions

  app.sub 'load file',        (event, id) -> loadFile(id)
  app.sub 'reload file',      (event, id) -> reloadFile(id)
  app.sub 'delete file',      (event, id) -> deleteFile(id)
  app.sub 'open directory',   (event, id) -> openDirectory(id)
  app.sub 'close directory',  (event, id) -> closeDirectory(id)
  app.sub 'toggle directory', (event, id) -> toggleDirectory(id)

