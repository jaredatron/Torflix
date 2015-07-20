#= require 'eventemitter3'

Putio.Files = class Files extends EventEmitter
  constructor: (putio) ->
    @putio = putio
    @files_cache = {}
    @directory_contents_cache = {}

  get: (id) ->
    files_cache = @files_cache
    return Promise.resolve(files_cache[id]) if id of files_cache
    @putio.get("/files/#{id}")
      .then (response) ->
        files_cache[id] = response.file
      .catch (error) ->
        throw error if error.xhr.status != 404
        files_cache[id] = null

  uncache: (file_id) ->
    delete @files_cache[file_id]
    delete @directory_contents_cache[file_id]
    return this

  list: (parent_id) ->
    parent_id ||= 0
    files_cache = @files_cache
    directory_contents_cache = @directory_contents_cache
    if parent_id of directory_contents_cache
      return Promise.resolve(directory_contents_cache[parent_id])
    @putio.get('/files/list', parent_id: parent_id)
      .then (response) ->
        files = response.files
        directory_contents_cache[parent_id] = files
        files.forEach (file) => files_cache[file.id] = file
        files
      .catch (error) ->
        throw error if error.xhr.status != 404
        directory_contents_cache[parent_id] = []



  delete: (id) ->
    throw new Error("File ID required: #{id}") unless id
    @putio.post('/files/delete', file_ids: id).then (response) ->
      @uncache(id)
      @putio.account.info.load()
      @emit("change:#{id}")
      response

  search: (query) ->
    @utio.get("/files/search/#{encodeURIComponent(query)}")

