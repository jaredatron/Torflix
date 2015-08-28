module.exports = (app) ->

  app.sub ['load file','load directory contents'], (event, fileId) ->
    app.set "files/#{fileId}/loading": true

    app.putio.directoryContents(fileId).then (response) ->
      {parent, files} = response
      parent.fileIds = files.map (file) -> file.id
      changes = {}
      changes["files/#{fileId}/loading"] = undefined
      changes["files/#{fileId}"] = amendFile(parent)
      for file in files
        changes["files/#{file.id}"] = amendFile(file)
      app.set changes


  app.sub 'toggle directory', (event, fileId) ->
    key = "/files/#{fileId}/open"
    app.set "#{key}": !app.get(key)



  amendFile = (file) ->
    file.isVideo = isVideo(file)
    file.isDirectory = isDirectory(file)
    file




  isVideo = (file) ->
    /\.(mkv|mp4|avi)$/.test file.name

  isDirectory = (file) ->
    file.content_type == "application/x-directory"

