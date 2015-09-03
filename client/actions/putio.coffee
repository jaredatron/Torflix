Putio = require '../Putio'

module.exports = (app) ->

  if matches = location.hash.match(/^#access_token=(.*)$/)
    app.set 'put_io_access_token': matches[1]
    app.clearHash()

  app.putio = new Putio(app)

  update = ->
    app.putio.setToken app.get('put_io_access_token')

  app.sub 'start', ->
    update()
    app.sub 'store:change:put_io_access_token', update

  app.sub 'stop', ->
    app.unsub 'store:change:put_io_access_token', update
