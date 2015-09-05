require 'shouldhave/Array#unique'
require 'shouldhave/Array#isEmpty'


module.exports = (app) ->

  STREAM_AUTH_TOKEN = 'WE NEED TO GET THIS FROM THE API???'
  OAUTH_TOKEN = ''

  get = (file) -> app.get "files/#{file.id}"
  set = (file) -> app.set "files/#{file.id}": file

  update = ({id}, changes) ->
    original = get({id})
    file = Object.assign({}, original || {id: id}, changes)
    amendFile(file)
    diff = diffObjects(original, file)

    if Object.keys(diff).isEmpty()
      # console.trace('not updating file, its the same')
      debugger
      return
    set(file)

    app.pub 'file changed',
      changeType: if original then 'UPDATE' else 'CREATED'
      id: file.id
      from: original
      to: file
      diff: diff

  del = (file) ->
    app.del "files/#{file.id}"
    app.pub 'file changed',
      changeType: 'DELETE'
      id: file.id,
      from: file,
      to: undefined

  amendFile = (file) ->
    file.loadedAt = Date.now()
    file.needsLoading = file.isDirectory && !file.fileIds
    file.isDirectory = true if file.id == 0


  loadFile = (file) ->
    file = get(file) || file
    return loadDirectoryContents(file) if file.isDirectory || file.id == 0
    update(file, loading: true)
    app.putio.file(file.id).then (file) ->
      update(file, loading: false)

  loadDirectoryContents = (file) ->
    update(file, loading: true)
    app.putio.directoryContents(file.id).then ({parent, files}) ->
      parent.loading = false
      update(parent, parent)
      for childFile in files
        childFile.loading = false
        update(childFile, childFile)
      {parent, files}

  deleteFile = (file) ->
    update file, isBeingDeleted: true
    app.putio.deleteFile(file.id).then ->
      loadDirectoryContents(id: file.parent_id).then ->
        del(file)

  openDirectory = (file) ->
    throw "file #{file.id} is not a directory" if !file.isDirectory
    update file, open: true
    loadDirectoryContents(file) if !file.fileIds

  closeDirectory = (file) ->
    throw "file #{file.id} is not a directory" if !file.isDirectory
    update file, open: false

# actions

  app.sub 'load file', (event, file) ->
    file = get(file) || {id: file.id, needsLoading: true}
    if file.needsLoading && !file.loading
      loadFile(file)

  app.sub 'reload file', (event, file) ->
    loadFile(file)

  app.sub 'open directory', (event, file) ->
    openDirectory(file)

  app.sub 'close directory', (event, file) ->
    closeDirectory(file)

  app.sub 'toggle directory', (event, file) ->
    file = get(file)
    if file.open
      closeDirectory(file)
    else
      openDirectory(file)
    # return unless file? && file.isDirectory
    # console.log('toggleing directory', file.id, !!file.open)
    # open = (if file.open then undefined else true)
    # update file, open: open
    # if open && !file.fileIds
    #   loadDirectoryContents(file)


  app.sub 'delete file', (event, file) ->
    deleteFile(file)



diffObjects = (a,b) ->
  a = Object(a)
  b = Object(b)

  keys = Object.keys(a).concat(Object.keys(b)).unique()

  diff = {}
  for key in keys
    aValue = a[key]
    bValue = b[key]
    continue if aValue == bValue
    diff[key] = [aValue, bValue]

  diff








