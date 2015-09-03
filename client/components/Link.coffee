Link = require 'reactatron/Link'

module.exports = Link.withStyle 'Link',

  outline: 'none'
  cursor: 'pointer'

  ':hover':
    textDecoration: 'underline'

  ':mousedown':
    textDecoration: 'underline'

  ':focus':
    textDecoration: 'underline'
