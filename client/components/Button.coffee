component = require 'reactatron/component'
Style = require 'reactatron/Style'

Button = require 'reactatron/Button'

module.exports = component 'Button',

  defaultStyle:
    cursor: 'pointer'
    border: '1px solid blue'
    backgroundColor: 'red'
    ':hover':
      border: '1px solid blue'
      backgroundColor: 'red'
    ':disabled':
      opacity: 0.5
      cursor: 'default'

  render: ->




