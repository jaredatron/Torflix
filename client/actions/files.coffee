module.exports = (app) ->

  STREAM_AUTH_TOKEN = 'WE NEED TO GET THIS FROM THE API???'
  OAUTH_TOKEN = ''

  get = (file) -> app.get "files/#{file.id}"
  set = (file) -> app.set "files/#{file.id}": file
  del = (file) -> app.del "files/#{file.id}"

  extend = (updates) ->
    file = get(updates.id)
    file = if file?
      Object.assign(file, updates)
    else
      updates

  update = (updates) ->
    file = extend(updates)
    amendFile(file)
    set(file)


  amendFile = (file) ->
    file.loadedAt = Date.now()
    file.needsLoading = file.isDirectory && !file.fileIds


  loadFile = (file) ->
    return loadDirectoryContents(file) if file.isDirectory || file.id == 0
    file.loading = true
    update(file)
    app.putio.file(file.id).then (file) ->
      file.loading = false
      update(file)

  loadDirectoryContents = ({id}) ->
    app.putio.directoryContents(id).then ({parent, files}) ->
      parent.needsLoading = false
      files.unshift parent
      for file in files
        file.loading = false
        update(file)

  deleteFile = (file) ->
    file.isBeingDeleted = true
    update(file)
    app.putio.deleteFile(file.id).then (response) ->
      debugger
      del(file)

# actions

  app.sub 'load file', (event, file) ->
    file = get(file) || {id: file.id, needsLoading: true}
    if file.needsLoading && !file.loading
      loadFile(file)

  app.sub 'reload file', (event, file) ->
    loadFile(file)

  app.sub 'toggle directory', (event, file) ->
    file = get(file)
    return unless file? && file.isDirectory
    if file.open
      delete file.open
    else
      file.open = true
      loadFile(file) if file.needsLoading
    set(file)

  app.sub 'delete file', (event, file) ->
    console.warn('DELEITNG FILE', file)
