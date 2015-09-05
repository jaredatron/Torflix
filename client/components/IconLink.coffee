toArray = require 'shouldhave/toArray'
component = require 'reactatron/component'
Link = require './Link'

module.exports = IconLink = component (props) ->
  props.extendStyle
    # flexGrow: 1
    flexShrink: 10
    # overflow: 'hidden'
    # textOverflow: 'ellipsis'

  icon = Icon
    glyph: props.glyph,
    fixedWidth: true,
    style:
      marginRight: '0.5em'

  props.children = toArray(props.children)
  props.children.unshift icon

  Link(props)
