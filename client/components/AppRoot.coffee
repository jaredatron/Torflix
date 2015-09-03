component = require 'reactatron/component'
Block = require 'reactatron/Block'

module.exports = component 'AppRoot',

  dataBindings: ->
    route: 'route'

  render: ->
    {page, path, params} = @state.route
    @app.pages[page]({path, params})

