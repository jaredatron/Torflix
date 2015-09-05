isNumber = require 'shouldhave/isNumber'

component = require 'reactatron/component'

{i} = require 'reactatron/DOM'


FontAwesome = require '../FontAwesome'

module.exports = component 'Icon',

  propType:
    glyph:      component.PropTypes.oneOf(Object.keys(FontAwesome.glyphMap)).isRequired
    fixedWidth: component.PropTypes.bool

  defaultStyle:
    display:             'inline-block'
    font:                'normal normal normal 14px/1 FontAwesome'
    # fontSize:            '85%'
    textRendering:       'auto'
    WebkitFontSmoothing: 'antialiased'
    MozOsxFontSmoothing: 'grayscale'

  render: ->
    charCode = FontAwesome.glyphMap[@props.glyph]
    if isNumber(charCode)
      glyph = String.fromCharCode(charCode)
    else
      console.warn("unknown font awesome glyph #{@props.glyph}")
      glyph = '?'

    props = @cloneProps()
    if @props.fixedWidth
      props.extendStyle
        width: '1em'
        textAlign: 'center'

    i props, glyph




