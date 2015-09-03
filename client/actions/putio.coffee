Putio = require '../Putio'

module.exports = (app) ->

  app.putio = new Putio(app)

  update = ->
    app.putio.setToken app.get('put_io_access_token')

  app.sub 'store:change:put_io_access_token', update
  update()
