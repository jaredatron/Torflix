component    = require 'reactatron/component'
Style        = require 'reactatron/Style'
SafetyButton = require './SafetyButton'
Icon         = require './Icon'
Link         = require './Link'


module.exports = component 'DeleteButton',
  propTypes:
    onClick: component.PropTypes.func

  defaultStyle:
    flexDirection: 'row-reverse'

  deleteFile: (event) ->
    event.preventDefault() if event?
    console.log('would delete', @props.file)

  render: ->
    SafetyButton @extendProps
      defaultButton:
        Button glyph: 'trash-o'
      abortButton:
        Button glyph: 'ban'
      confirmButton:
        Button glyph: 'trash-o',
          onClick: @props.onClick
          style:
            color: 'red'
            marginRight: '0.5em'


Button = component (props) ->
  props.extendStyle
    opacity: 0.2
    ':hover':
      opacity: 0.76
      color:' purple'
    ':focus':
      opacity: 1
      color:' orange'

  Link(props, Icon(glyph:props.glyph))




  # component 'DeleteFileButton',
  # propTypes:
  #   file: component.PropTypes.object.isRequired

  # defaultStyle:
  #   flexDirection: 'row-reverse'

  # deleteFile:

  # render: ->
  #   SafetyButton @extendProps
  #     defaultButton:
  #       Link
  #         key: 'default'
  #         style: HoverOpacityStyle
  #         Icon(glyph: 'trash-o')
  #     abortButton:
  #       Link
  #         key: 'abort'
  #         style: HoverOpacityStyle
  #         Icon(glyph: 'ban')
  #     confirmButton:
  #       Link
  #         key: 'confirm'
  #         onClick: @deleteFile
  #         style: HoverOpacityStyle.merge
  #           color: 'red'
  #           marginRight: '0.5em'
  #         Icon(glyph: 'trash-o')



