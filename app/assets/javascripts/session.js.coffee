#= require 'eventemitter3'
#= require 'Object.assign'

PREFIX = "TORFLIX/"

@session = (key, value) ->
  throw new Error('key cannot be blank') if !key?
  if arguments.length == 1
    value = localStorage["#{PREFIX}#{key}"]
    return if value? then JSON.parse(value) else null

  if arguments.length == 2
    if value == null
      delete localStorage["#{PREFIX}#{key}"]
      setTimeout ->
        session.emit('change')
        session.emit("change:#{key}", null)
    else
      json = JSON.stringify(value)
      value = JSON.parse(json)
      if localStorage["#{PREFIX}#{key}"] != json
        localStorage["#{PREFIX}#{key}"] = json
        setTimeout ->
          session.emit('change')
          session.emit("change:#{key}", value)
    value

Object.assign(session, EventEmitter.prototype)
