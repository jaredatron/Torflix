component = require 'reactatron/component'
Link = require './Link'

module.exports = component (props) ->
  props.href ||= 'https://github.com/deadlyicon/Torflix-chrome-extension'
  Link(props)
