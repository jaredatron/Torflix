#= require 'eventemitter3'
#= require 'Object.assign'
#= require 'qwest'
#= require 'session'

Putio = @Putio = 

  ENDPOINT: 'https://api.put.io/v2'

  TOKEN: null

  url: (path) ->
    throw new Error('please set Putio.TOKEN') if !@TOKEN?
    "#{@ENDPOINT}#{path}?oauth_token=#{@TOKEN}"
  
  get: (path, params) ->
    # console.info('PUTIO GET', path, params)
    qwest.get(Putio.url(path), params)

  post: (path, params) ->
    # console.info('PUTIO POST', path, params)
    qwest.post(Putio.url(path), params)

Putio.cache = {}

Putio.account = {}

Putio.account.info = Object.assign({}, EventEmitter.prototype)

Putio.account.info.load = ->
  Putio.get('/account/info').then (response) =>
    Object.assign(this, response.info)
    @emit('change')
    response.info


Putio.cache.transfers = []

Putio.transfers = Object.assign({}, EventEmitter.prototype)

Putio.transfers.toArray = ->
  [].concat(Putio.cache.transfers) # clone

Putio.transfers.load = ->
  Putio.get('/transfers/list').then (response) =>
    Putio.cache.transfers = response.transfers
    @emit('change')
    response

Putio.transfers.TRANSFER_POLL_DELAY = 1000 * 3
Putio.transfers.polling = false
Putio.transfers.startPolling = ->
  return this if @polling
  @polling = true
  load = ->
    return unless Putio.transfers.polling
    Putio.transfers.load().complete ->
      setTimeout(load, Putio.transfers.TRANSFER_POLL_DELAY)
  load()
  this

Putio.transfers.stopPolling = ->
  @polling = false
  this

Putio.transfers.add = (url) ->
  Putio.post('/transfers/add', url: url).then (response) =>
    transfers.push response.transfer
    Putio.account.info.load()
    @emit('change')
    response


Putio.transfers.delete = (id) ->
  transfer = transfers.filter((transfer) -> transfer.id == id)[0]

  delete_transfer_promise = Putio.post('/transfers/cancel', transfer_ids: id).then (response) =>
    transfers = transfers.filter((transfer) -> transfer.id != id)
    @emit('change')
    response

  Putio.account.info.load()

  return delete_transfer_promise unless transfer? && transfer.file_id

  delete_file_promise = Putio.files.delete(transfer.file_id)
  Promise.all([delete_transfer_promise,delete_file_promise])



Putio.cache.files = {}
Putio.cache.directory_contents = {}
Putio.files = Object.assign({}, EventEmitter.prototype)

Putio.files.get = (id) ->
  return Promise.resolve(file) if file = Putio.cache.files[id]
  Putio.get("/files/#{id}").then (response) =>
    file = response.file
    Putio.cache.files[file.id] = file
    file

    # https://api.put.io/v2/files/list?parent_id=270984407&oauth_token=VXWAPF8R&__t=1422230397270

Putio.files.clearCache = (file_id) ->
  delete Putio.cache.files[file_id]
  delete Putio.cache.directory_contents[file_id]
  return this

Putio.files.list = (parent_id) ->
  parent_id ||= 0
  return Promise.resolve(files) if files = Putio.cache.directory_contents[parent_id]
  Putio.get('/files/list', parent_id: parent_id).then (response) =>
    files = response.files
    Putio.cache.directory_contents[parent_id] = files
    files.forEach (file) -> Putio.cache.files[file.id] = file
    files

Putio.files.delete = (id) ->
  throw new Error("File ID required: #{id}") unless id
  Putio.post('/files/delete', file_ids: id).then (response) ->
    delete Putio.cache.files[id]
    Putio.account.info.load()
    Putio.files.emit("change:#{id}")
    response

Putio.files.search = (query) ->
  Putio.get("/files/search/#{encodeURIComponent(query)}")


Putio.init = ->
  Putio.getTokenFromHash()
  Putio.TOKEN = session('put_io_access_token')

Putio.getTokenFromHash = ->
  if matches = location.hash.match(/^#access_token=(.*)$/)
    session('put_io_access_token', matches[1])
    window.location = location.toString().substring(0, location.href.indexOf('#'))
