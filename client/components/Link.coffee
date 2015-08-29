Link = require 'reactatron/Link'

module.exports = Link.withStyle 'Link',

  outline: 'none'
  cursor: 'pointer'

  ':hover':
    zIndex: 2
    textDecoration: 'underline'
    # textShadow: '0 0 5px rgba(0,85,255,0.25)'

  # ':active': ???
  ':mousedown':
    zIndex: 2
    textDecoration: 'underline'
    # textShadow: '0 0 5px rgba(0,85,255,0.75)'

  ':focus':
    zIndex: 2
    textDecoration: 'underline'
    # textShadow: '0 0 5px rgba(0,85,255,0.5)'
    # outline: '1px solid red'
