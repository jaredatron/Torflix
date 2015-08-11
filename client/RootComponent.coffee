React = require('react')
component = require('reactatron/component')

module.exports = component 'RootComponent',

  propTypes:
    path:   React.PropTypes.string.isRequired
    params: React.PropTypes.object.isRequired

  render: ->
    {div} = React.DOM
    div(null, 'ROOT COMPONENT')

