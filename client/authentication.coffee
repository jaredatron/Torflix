component = require('reactatron/component')

module.exports = (app) ->

  update = ->
    console.log('loggedIn update')
    app.set loggedIn: app.get('put_io_access_token')?

  app.logout = ->
    app.set put_io_access_token: undefined

  app.login = (token) ->
    app.set put_io_access_token: token

  console.log(app.events.subscriptions)

  app.sub 'start', ->
    update()
    app.sub 'store:change:put_io_access_token', update

  app.sub 'stop', ->
    app.unsub 'store:change:put_io_access_token', update


  if matches = location.hash.match(/^#access_token=(.*)$/)
    app.set 'put_io_access_token': matches[1], loggedIn: true
    app.clearHash()
