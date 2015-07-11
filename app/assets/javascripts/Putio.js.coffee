#= require 'eventemitter3'
#= require 'Object.assign'
#= require 'qwest'
#= require 'session'

@Putio = class Putio extends EventEmitter

  constructor: (token) ->
    @TOKEN = token
    @cache = {}
    @account = {}
    @account.info = new AccountInfo(this)
    @transfers = new Transfers(this)
    # @files     = new Files(this)


  ENDPOINT: 'https://api.put.io/v2'

  TOKEN: null

  url: (path) ->
    "#{@ENDPOINT}#{path}?oauth_token=#{@TOKEN}"
  
  get: (path, params) ->
    # console.info('PUTIO GET', path, params)
    qwest.get(@url(path), params)

  post: (path, params) ->
    # console.info('PUTIO POST', path, params)
    qwest.post(@url(path), params)


class AccountInfo extends EventEmitter
  constructor: (putio) ->
    @putio = putio
  
  load: ->
    @putio.get('/account/info').then (response) =>
      Object.assign(this, response.info)
      @emit('change')
      this


class Transfers extends EventEmitter
  constructor: (putio) ->
    @putio = putio
    @cache = []
    @polling = false

  toArray: ->
    [].concat(@cache) # clone

  load: ->
    @putio.get('/transfers/list').then (response) =>
      @cache = response.transfers
      # @cache = response.transfers.map (props) ->
      #   new Transfer(props)
      @emit('change')
      response

  TRANSFER_POLL_DELAY: 1000 * 3

  startPolling: ->
    return this if @polling
    @polling = true
    TRANSFER_POLL_DELAY = @TRANSFER_POLL_DELAY
    load = =>
      return unless @polling
      @load().complete ->
        setTimeout(load, TRANSFER_POLL_DELAY)
    load()
    this

  stopPolling: ->
    @polling = false
    this

  add: (url) ->
    @putio.post('/transfers/add', url: url).then (response) =>
      @cache.push response.transfer
      @putio.account.info.load()
      @emit('change')
      response


  delete: (id) ->
    transfer = @cache.filter((transfer) -> transfer.id == id)[0]

    delete_transfer_promise = @putio.post('/transfers/cancel', transfer_ids: id).then (response) =>
      @cache = transfers.filter((transfer) -> transfer.id != id)
      @emit('change')
      response

    @putio.account.info.load()

    return delete_transfer_promise unless transfer? && transfer.file_id

    delete_file_promise = @putio.files.delete(transfer.file_id)
    Promise.all([delete_transfer_promise,delete_file_promise])



# Putio.cache.files = {}
# Putio.cache.directory_contents = {}
# Putio.files = Object.assign({}, EventEmitter.prototype)

# Putio.files.get = (id) ->
#   return Promise.resolve(file) if file = Putio.cache.files[id]
#   Putio.get("/files/#{id}").then (response) =>
#     file = response.file
#     Putio.cache.files[file.id] = file
#     file

#     # https://api.put.io/v2/files/list?parent_id=270984407&oauth_token=VXWAPF8R&__t=1422230397270

# Putio.files.clearCache = (file_id) ->
#   delete Putio.cache.files[file_id]
#   delete Putio.cache.directory_contents[file_id]
#   return this

# Putio.files.list = (parent_id) ->
#   parent_id ||= 0
#   return Promise.resolve(files) if files = Putio.cache.directory_contents[parent_id]
#   Putio.get('/files/list', parent_id: parent_id).then (response) =>
#     files = response.files
#     Putio.cache.directory_contents[parent_id] = files
#     files.forEach (file) -> Putio.cache.files[file.id] = file
#     files

# Putio.files.delete = (id) ->
#   throw new Error("File ID required: #{id}") unless id
#   Putio.post('/files/delete', file_ids: id).then (response) ->
#     delete Putio.cache.files[id]
#     Putio.account.info.load()
#     Putio.files.emit("change:#{id}")
#     response

# Putio.files.search = (query) ->
#   Putio.get("/files/search/#{encodeURIComponent(query)}")


