PREFIX = "PUTIO/"

session = (key, value) ->
  if arguments.length == 1
    value = localStorage["#{PREFIX}#{key}"]
    return if value? then JSON.parse(value) else null

  if arguments.length == 2
    json = JSON.stringify(value)
    if localStorage["#{PREFIX}#{key}"] != json
      localStorage["#{PREFIX}#{key}"] = json
      session.emit('change')
    value

assign(session, EventEmitter.prototype)

module.exports = session

global.session = session