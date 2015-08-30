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

    app.putio.directoryContents(fileId).then (response) ->
      {parent, files} = response
      parent.fileIds = files.map(pluckId)
      files.unshift parent
      for file in files
        file.loading = false
        updateAndAmmend(file)


  # files loaded as directory contents to not have
  # directory contents
  filesLoaded = (file) ->
    return file.isDirectory && file.fileIds



# actions

  app.sub 'load file', (event, fileId) ->
    loadFile(fileId)

  app.sub 'toggle directory', (event, fileId) ->
    return unless file = get(fileId) && file.isDirectory
    if file.open
      delete file.open
    else
      file.open = true
      loadFile file.id if file.needsLoading
    set(file)





# statics

pluckId = (f) -> f.id

