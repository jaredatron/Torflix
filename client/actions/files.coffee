module.exports = (app) ->

  STREAM_AUTH_TOKEN = 'WE NEED TO GET THIS FROM THE API???'
  OAUTH_TOKEN = ''

  get = (fileId) -> app.get "files/#{fileId}"
  set = (file)   -> app.set "files/#{file.id}": file

  update = (updates) ->
    file = get(updates.id)
    set file and Object.assign(file, updates) or file = updates

  loadFile = (fileId) ->
    update id: fileId, loading: true

    app.putio.directoryContents(fileId).then ({parent, files}) ->
      files.unshift parent
      for file in files
        file.loading = false
        update(file)


  # files loaded as directory contents to not have
  # directory contents
  filesLoaded = (file) ->
    return file.isDirectory && file.fileIds



# actions

  app.sub 'load file', (event, fileId) ->
    loadFile(fileId)

  app.sub 'reload file', (event, fileId) ->
    set id: fileId, loading: true, fileIds: undefined
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




