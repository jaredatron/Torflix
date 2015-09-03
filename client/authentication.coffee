component = require('reactatron/component')

module.exports = (app) ->

  update = ->
    app.set loggedIn: app.get('put_io_access_token')?

  app.logout = ->
    app.set put_io_access_token: undefined

  app.login = (token) ->
    app.set put_io_access_token: token

  app.sub 'store:change:put_io_access_token', update
  app.unsub 'store:change:put_io_access_token', update
