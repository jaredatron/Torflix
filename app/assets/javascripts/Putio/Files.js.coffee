#= require 'eventemitter3'

Putio.Files = class Files extends EventEmitter
  constructor: (putio) ->
    @putio = putio
    @files_cache = {}
    @directory_contents_cache = {}

  get: (id) ->
    return Promise.resolve(file) if file = @files_cache[id]
    @putio.get("/files/#{id}").then (response) =>
      file = response.file
      @files_cache[file.id] = file

  uncache: (file_id) ->
    delete @files_cahce[file_id]
    delete @directory_contents_cahce[file_id]
    return this

  list: (parent_id) ->
    parent_id ||= 0
    files = @directory_contents_cache[parent_id]
    return Promise.resolve(files) if files
    @putio.get('/files/list', parent_id: parent_id).then (response) =>
      files = response.files
      @directory_contents[parent_id] = files
      files.forEach (file) -> @files_cache[file.id] = file
      files

  delete: (id) ->
    throw new Error("File ID required: #{id}") unless id
    @putio.post('/files/delete', file_ids: id).then (response) ->
      @uncache(id)
      @putio.account.info.load()
      @emit("change:#{id}")
      response

  search: (query) ->
    @utio.get("/files/search/#{encodeURIComponent(query)}")

