component = require 'reactatron/component'
{div, h1} = require 'reactatron/DOM'
Link = require '../components/Link'

module.exports = component 'TransfersPage',

  contextTypes:
    params: component.PropTypes.object

  render: ->
    div
      className: 'TransfersPage'
      h1(null, 'Trasnfers')
      div null, JSON.stringify(@context.params)
      div null,
        Link href: '/', 'Home'
