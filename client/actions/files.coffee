module.exports = (app) ->

  app.sub ['load file','load directory contents'], (event, fileId) ->
    app.putio.directoryContents(fileId).then (response) ->
      {parent, files} = response
      parent.fileIds = files.map (file) -> file.id
      changes = {}
      changes["files/#{fileId}"] = parent
      for file in files
        changes["files/#{file.id}"] = file
      app.set changes

