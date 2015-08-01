#= require Object.assign
#= require eventemitter3

class Putio.Transfer extends EventEmitter

  constructor: (props) ->
    @update(props)

  update: (props) ->
    Object.assign(this, props)
    @isComplete    = @finished_at?
    @isDownloading = "DOWNLOADING" == @status
    @isDeleting    = false unless @isDeleting?
    @isDeleted     = false unless @isDeleted?
    @emit('change')

  file: ->
    App.putio.files.get(@file_id)

  delete: ->
    @isDeleting = true
    @emit('change')
    App.putio.transfers.delete(@id).then =>
      @isDeleting = false
      @isDeleted = true
