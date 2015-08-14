component = require 'reactatron/component'
{div} = require 'reactatron/DOM'

module.exports = component 'NotFoundPage',
  render: ->
    div(null, 'Page Not Found :(')
