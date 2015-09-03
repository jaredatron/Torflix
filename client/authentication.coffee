component = require('reactatron/component')

module.exports = (app) ->

  update = ->
    console.log('loggedIn update')
    app.set loggedIn: app.get('put_io_access_token')?

  app.logout = ->
    app.set put_io_access_token: undefined

  app.login = (token) ->
    app.set put_io_access_token: token

  if matches = location.hash.match(/^#access_token=(.*)$/)
    app.set 'put_io_access_token': matches[1], loggedIn: true
    app.clearHash()

  app.sub 'store:change:put_io_access_token', update
  update()
