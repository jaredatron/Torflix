#= require 'eventemitter3'
#= require 'Object.assign'

PREFIX = "TORFLIX/"

App.session = (key, value) ->
  throw new Error('key cannot be blank') if !key?
  if arguments.length == 1
    value = localStorage["#{PREFIX}#{key}"]
    return if value? then JSON.parse(value) else null

  if arguments.length == 2
    if value == null
      delete localStorage["#{PREFIX}#{key}"]
      setTimeout ->
        App.session.emit('change')
        App.session.emit("change:#{key}", null)
    else
      json = JSON.stringify(value)
      value = JSON.parse(json)
      if localStorage["#{PREFIX}#{key}"] != json
        localStorage["#{PREFIX}#{key}"] = json
        setTimeout ->
          App.session.emit('change')
          App.session.emit("change:#{key}", value)
    value

Object.assign(App.session, EventEmitter.prototype)



getPutioTokenFromHash = ->
  if matches = location.hash.match(/^#access_token=(.*)$/)
    App.session('put_io_access_token', matches[1])
    window.location = location.toString().substring(0, location.href.indexOf('#'))

getPutioTokenFromHash()
