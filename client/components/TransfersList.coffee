TransitionGroup = require 'reactatron/TransitionGroup'

component  = require 'reactatron/component'
Space      = require 'reactatron/Space'
Text       = require 'reactatron/Text'
SublteText = require 'reactatron/SublteText'
Columns    = require 'reactatron/Columns'
Rows       = require 'reactatron/Rows'
Box        = require 'reactatron/Box'
Block      = require 'reactatron/Block'
RemainingSpace      = require 'reactatron/RemainingSpace'
Link       = require './Link'
Button     = require './Button'
Icon       = require './Icon'
FileSize   = require './FileSize'
SafetyButton   = require './SafetyButton'
DeleteButton   = require './DeleteButton'

{progress} = require 'reactatron/DOM'


module.exports = component 'TransfersList',

  propTypes:
    transfers: component.PropTypes.any

  # shouldComponentUpdate: (nextProps, nextState) ->
  #   if @props.transfers? && @nextProps.nextProps?

  childFactory: (child) ->
    child
    # TestAnimator {}, child

  renderTransfers: ->
    (@props.transfers || []).sort(SORT).map (transfer, index) ->
      Transfer key: transfer.id, transfer: transfer

  render: ->
    transfers = @renderTransfers()

    # TransitionGroup
    #   component: Rows,
    #   childFactory: @childFactory
    #   style: width: '100%'
    #   transfers

    Rows
      style: width: '100%'
      transfers

Transfer = component 'Transfer',

  deleteTransfer: ->
    @app.pub 'delete transfer', @props.transfer.id

  defaultStyle:
    padding: '0.5em 0.5em'
    alignItems: 'center'
    borderTop: '1px solid rgb(235,235,235)'
    ':hover':
      backgroundColor: '#DFEBFF'

  shouldComponentUpdate: (nextProps, nextState) ->
    a = @props.transfer
    b = nextProps.transfer
    # console.log('????', a,b)

    return false if (
      a.id     != b.id     ||
      a.status != b.status
    )
    true

  render: ->
    transfer = @props.transfer

    opacity = transfer.status == 'DELETING' && 0.2 || 1


    Columns @cloneProps(),
      Rows
        style:
          opacity: opacity
          marginRight: '0.5em'
          flexGrow: 1
          flexShrink: 1
          overflow: 'hidden'
        Columns {},
          Block
            style:
              flexShrink: 1
              overflow: 'hidden'
              textOverflow: 'ellipsis'
              whiteSpace: 'nowrap'

            LinkToTransferFiles(transfer)
          Space()
          Block {}, transfer.status
          Space()
          LinkToTransferMagnetLink(transfer)
          Space()
          LinkToDownloadTransfer(transfer)
          # Space()
          # Block {}, "STATSUS: #{transfer.status}"
          # Space()
          # DeleteButton onClick: -> console.log('78787878787878')
          RemainingSpace {} #style: {flexGrow: 1, flexShrink: 2}
          Space()
          Block style: {width: '3em'},
            FileSize size: transfer.size, style: SublteText.style

        TransferProgress(transfer)
        SublteText
          style:
            overflow: 'hidden'
            textOverflow: 'ellipsis'
            whiteSpace: 'nowrap'
          transfer.status_message
      DeleteTransferButton onClick: @deleteTransfer


TransferProgress = (transfer) ->
  # return null if transfer.status == 'COMPLETED'
  progress
    value: transfer.percent_done
    max: 100
    style:
      width: '100%'


DeleteTransferButton = component 'DeleteTransferButton', (props) ->
  SafetyButton

    defaultButton:
      Button {}, Icon(glyph: 'trash-o')

    confirmButton:
      Button
        onClick: props.onClick
        style:
          borderRadius: '4px 0 0 4px'
        Icon glyph: 'check'

    abortButton:
      Button
        style:
          borderWidth: '1px 1px 1px 0'
          borderRadius: '0 4px 4px 0'
        Icon glyph: 'times'



LinkToTransferFiles = (transfer) ->
  style =
    textOverflow: 'ellipsis'
    whiteSpace: 'nowrap'
    overflow: 'hidden'
  switch transfer.status
    when 'COMPLETED', 'SEEDING'
      Link
        style: style
        path: "/files/#{transfer.file_id}",
        transfer.name
    else
      Block(style:style, transfer.name)

LinkToTransferMagnetLink = (transfer) ->
  Link href: transfer.magneturi,
    Icon glyph: 'link'

LinkToDownloadTransfer = (transfer) ->
  onClick = (event) ->
    event.preventDefault()
    console.log('would download', transfer)
  Link onClick: onClick, Icon(glyph: 'download')



animator = require '../animator'



# ReactTransitionEvents = require 'react/lib/ReactTransitionEvents'
TestAnimator = component 'TestAnimator',
  componentWillMount: ->
    # console.log('componentWillMount')

  componentDidMount: ->
    # console.log('componentDidMount')

  componentWillUnmount: ->
    # console.log('componentWillUnmount')

  componentWillAppear: (done) ->
    # console.log('componentWillAppear')
    done()

  componentWillEnter: (done) ->
    # console.log('componentWillEnter')
    animator.animate
      target: @getDOMNode()
      name: 'bounceInLeft'
      duration: '500ms'
      done: done

  componentWillLeave: (done) ->
    # console.log('componentWillLeave')
    animator.animate
      target: @getDOMNode()
      name: 'bounceOutLeft'
      duration: '500ms'
      done: done

  render: ->
    @props.children[0]




SORT = (a, b) ->
  a = Date.parse(a.created_at)
  b = Date.parse(b.created_at)
  return -1 if a > b
  return  1 if a < b
  return  0 if a == b
