React = require('react/addons')
# ReactCSSTransitionGroup = React.createFactory(React.addons.CSSTransitionGroup)
# ReactTransitionGroup = React.createFactory()


component = require 'reactatron/component'

Text = require 'reactatron/Text'
SublteText = require 'reactatron/SublteText'
Columns = require 'reactatron/Columns'
Rows = require 'reactatron/Rows'
Link = require 'reactatron/Link'
Button = require 'reactatron/Button'

TransitionGroup = require 'reactatron/TransitionGroup'

{progress} = require 'reactatron/DOM'



animate = (node, name, done) ->
  node.style.animationDuration = '1s'
  node.style.animationFillMode = 'both'


# ReactTransitionEvents = require 'react/lib/ReactTransitionEvents'
TestAnimator = component
  componentWillMount: ->
    console.log('componentWillMount')

  componentDidMount: ->
    console.log('componentDidMount')
    node = @getDOMNode()
    node.style.position = 'relative'
    # node.style.transition = 'left 500ms'

  componentWillUnmount: ->
    console.log('componentWillUnmount')

  componentWillAppear: (done) ->
    console.log('componentWillAppear')
    done()
    # node = @getDOMNode()
    # node.style.left = '-100%'
    # node.style.transition = 'left 500ms'
    # setTimeout ->
    #   node.style.left = '-0%'
    # setTimeout ->
    #   node.style.transition = ''
    #   done()
    # , 500

  componentWillEnter: (done) ->
    console.log('componentWillEnter')
    # done()
    node = @getDOMNode()
    node.style.left = '-100%'
    node.style.transition = 'left 500ms'
    setTimeout ->
      node.style.left = '-0%'
    , 10
    setTimeout ->
      # node.style.transition = ''
      done()
    , 500

  componentWillLeave: (done) ->
    console.log('componentWillLeave')
    # done()
    node = @getDOMNode()
    node.style.left = '-0%'
    node.style.transition = 'left 500ms'
    setTimeout ->
      node.style.left = '-100%'
    setTimeout ->
      node.style.transition = ''
      done()
    , 500

  render: ->
    @props.children



module.exports = component 'TransfersList',

  propTypes:
    transfers: component.PropTypes.any

  render: ->
    transfers = @renderTransfers()

    # Rows @cloneProps(), transfers

    TransitionGroup
      component: Rows,
      childFactory: @childFactory
      style: width: '100%'
      transfers

  childFactory: (child) ->
    TestAnimator {}, child

  renderTransfers: ->
    (@props.transfers || []).map (transfer, index) ->
      Transfer
        stripe: index % 2 == 1
        key: transfer.id
        transfer: transfer

Transfer = component 'Transfer',

  deleteTransfer: ->
    @app.pub 'delete transfer', @props.transfer

  render: ->
    transfer = @props.transfer

    style =
      padding: '0.25em 0.5em'
      backgroundColor: if @props.stripe then 'rgb(235,235,235)' else 'rgb(255,255,255)'


        # TransferStatus {}, transfer.status
    Rows shrink: 0, style: style,
      Link path: "/transfers/#{transfer.id}",
        Text {}, transfer.name
      Columns {},
        progress value: transfer.percent_done, max: 100, style: {flexGrow: 1, marginRight: '0.5em'}
        Button onClick: @deleteTransfer, 'X'
      SublteText {}, transfer.status_message


