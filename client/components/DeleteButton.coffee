component    = require 'reactatron/component'
Columns      = require 'reactatron/Columns'
Space        = require 'reactatron/Space'
SafetyButton = require './SafetyButton'
Icon         = require './Icon'
Link         = require './Link'


module.exports = component 'DeleteButton',
  propTypes:
    onClick: component.PropTypes.func

  getInitialState: ->
    confirming: false

  deleteFile: (event) ->
    event.preventDefault() if event?
    console.log('would delete', @props.file)

  confirmDelete: ->
    @setState confirming: true

  delete: (event) ->
    @setState confirming: false
    @props.onClick(event)

  abort:  ->
    @setState confirming: false

  onBlur: ->
    @scheduleAbort()

  scheduleAbort: ->
    @abortTimeout ||= setTimeout(@abort)
    null

  onFocus: ->
    clearTimeout(@abortTimeout)
    delete @abortTimeout
    null


  render: ->
    props = @extendProps
      onClick: undefined
      onBlur: @onBlur
      onFocus: @onFocus
      style:
        flexDirection: 'row-reverse'
    if @state.confirming
      Columns props,
        Button glyph: 'ban',     onClick: @abort
        Space()
        Button glyph: 'trash-o', onClick: @delete, red: true
    else
      Columns props,
        Button glyph: 'trash-o', onClick: @confirmDelete

Button = component (props) ->
  if props.red
    props.extendStyle
      color: 'rgba(255,0,0,0.5)'
      ':hover':
        color: 'rgba(255,0,0,1)'
      ':focus':
        color: 'rgba(255,0,0,1)'
  else
    props.extendStyle
      color: 'rgba(0,0,0,0.5)'
      ':hover':
        color: 'rgba(0,0,0,1)'
      ':focus':
        color: 'rgba(0,0,0,1)'

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



