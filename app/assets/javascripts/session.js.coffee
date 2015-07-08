#= require 'eventemitter3'
#= require 'Object.assign'

PREFIX = "TORFLIX/"

@session = (key, value) ->
  throw new Error('key cannot be blank') if !key?
  if arguments.length == 1
    value = localStorage["#{PREFIX}#{key}"]
    return if value? then JSON.parse(value) else null

  if arguments.length == 2
    json = JSON.stringify(value)
    if localStorage["#{PREFIX}#{key}"] != json
      localStorage["#{PREFIX}#{key}"] = json
      session.emit('change')
    value

Object.assign(session, EventEmitter.prototype)
