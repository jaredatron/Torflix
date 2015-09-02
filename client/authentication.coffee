component = require('reactatron/component')

module.exports = (app) ->

  app.logout = ->
    app.set put_io_access_token: undefined

  app.sub 'store:change:put_io_access_token', ->
    app.set loggedIn: app.get('put_io_access_token')?

  MainComponent = app.MainComponent
  app.MainComponent = component 'App',

    dataBindings: ->
      loggedIn: 'loggedIn'

    render: ->
      console.info('App render', @state)
      if @state.loggedIn
        MainComponent()
      else
        require('./pages/LoginPage')()



