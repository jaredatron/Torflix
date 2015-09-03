component = require 'reactatron/component'
Block = require 'reactatron/Block'

module.exports = component 'AppRoot',

  dataBindings: ->
    route: 'route'

  render: ->
    {page, params} = @state.route
    console.log('AppRoot#render', page, params)
    @app.pages[page](params)

