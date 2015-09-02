module.exports = (app) ->

  STREAM_AUTH_TOKEN = 'WE NEED TO GET THIS FROM THE API???'
  OAUTH_TOKEN = ''

  get = (fileId) -> app.get "files/#{fileId}"
  set = (file)   -> app.set "files/#{file.id}": file

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


  loadFile = (fileId) ->
    update id: fileId, loading: true
    app.putio.directoryContents(fileId).then ({parent, files}) ->
      parent.needsLoading = false
      files.unshift parent
      for file in files
        file.loading = false
        update(file)

# actions

  app.sub 'load file', (event, fileId) ->
    file = get(fileId)
    if !file? || (file.needsLoading && !file.loading)
      loadFile(fileId)

  app.sub 'reload file', (event, fileId) ->
    update id: fileId, loading: true
    loadFile(fileId)

  app.sub 'toggle directory', (event, fileId) ->
    file = get(fileId)
    return if !file? || !file.isDirectory
    if file.open
      delete file.open
    else
      file.open = true
      loadFile(file.id) if file.needsLoading
    set(file)




