EventEmitter = require 'eventemitter3'

module.exports = class AccountInfo extends EventEmitter
  constructor: (putio) ->
    @putio = putio

  load: ->
    @putio.get('/account/info').then (response) =>
      Object.assign(this, response.info)
      @emit('change')
      this
