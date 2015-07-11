#= require 'eventemitter3'

Putio.AccountInfo = class AccountInfo extends EventEmitter
  constructor: (putio) ->
    @putio = putio
  
  load: ->
    @putio.get('/account/info').then (response) =>
      Object.assign(this, response.info)
      @emit('change')
      this