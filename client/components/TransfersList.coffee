TransitionGroup = require 'reactatron/TransitionGroup'

component  = require 'reactatron/component'
Text       = require 'reactatron/Text'
SublteText = require 'reactatron/SublteText'
Columns    = require 'reactatron/Columns'
Rows       = require 'reactatron/Rows'
Link       = require './Link'
Button     = require './Button'

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
    (@props.transfers || []).map (transfer, index) ->
      Transfer
        stripe: index % 2 == 1
        key: transfer.id
        transfer: transfer

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
    @app.pub 'delete transfer', @props.transfer

  defaultStyle:
    padding: '0.5em 0.5em'
    alignItems: 'center'
    borderTop: '1px solid rgb(235,235,235)'

  render: ->
    transfer = @props.transfer

    Columns @cloneProps(),
      Rows
        style:
          marginRight: '0.5em'
          flexGrow: 1
          flexShrink: 1
        Link path: "/files/#{transfer.file_id}", transfer.name
        progress
          value: transfer.percent_done
          max: 100
          style:
            width: '100%'
        SublteText {}, transfer.status_message
      Button onClick: @deleteTransfer, 'X'






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
