React = require 'react'
App = require '../App'

module.exports = App.component 'PageNotFound',
  render: ->
    React.DOM.div(null, 'Page Not Found :(')