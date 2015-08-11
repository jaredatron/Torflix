React = require('react')
component = require('reactatron/component')

module.exports = component 'RootComponent',
  render: ->
    {div} = React.DOM
    div(null, 'ROOT COMPONENT')

