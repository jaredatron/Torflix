TransitionGroup = require 'reactatron/TransitionGroup'

component  = require 'reactatron/component'
Text       = require 'reactatron/Text'
SublteText = require 'reactatron/SublteText'
Columns    = require 'reactatron/Columns'
Rows       = require 'reactatron/Rows'
Link       = require 'reactatron/Link'
Button     = require 'reactatron/Button'

{progress} = require 'reactatron/DOM'


module.exports = component 'TransfersList',

  propTypes:
    transfers: component.PropTypes.any

  childFactory: (child) ->
    child
    # TestAnimator {}, child

  renderTransfers: ->
    (@props.transfers || []).map (transfer, index) ->
      Transfer
        stripe: index % 2 == 1
        key: transfer.id
        transfer: transfer

  render: ->
    transfers = @renderTransfers()

    TransitionGroup
      component: Rows,
      childFactory: @childFactory
      style: width: '100%'
      transfers

Transfer = component 'Transfer',

  deleteTransfer: ->
    @app.pub 'delete transfer', @props.transfer

  render: ->
    transfer = @props.transfer

    style =
      padding: '0.25em 0.5em'
      # backgroundColor: if @props.stripe then 'rgb(235,235,235)' else 'rgb(255,255,255)'
      borderBottom: '1px solid rgb(235,235,235)'


        # TransferStatus {}, transfer.status
    Rows shrink: 0, style: style,
      Link path: "/files/#{transfer.file_id}",
        Text {}, transfer.name
      Columns {},
        progress value: transfer.percent_done, max: 100, style: {flexGrow: 1, marginRight: '0.5em'}
        Button onClick: @deleteTransfer, 'X'
      SublteText {}, transfer.status_message






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
