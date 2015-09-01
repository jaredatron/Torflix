module.exports = (app) ->

  STREAM_AUTH_TOKEN = 'WE NEED TO GET THIS FROM THE API???'
  OAUTH_TOKEN = ''

  get = (fileId) -> app.get "files/#{fileId}"
  set = (file)   -> app.set "files/#{file.id}": file

  update = (updates) ->
    file = get(updates.id)
    file = if file?
      Object.assign(file, updates)
    else
      updates

    amendFile(file)
    set(file)


  amendFile = (file) ->
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
    console.log('load file', file)
    if !file? || (file.needsLoading && !file.loading)
      loadFile(fileId)

  app.sub 'reload file', (event, fileId) ->
    console.log('reload file', fileId)
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




