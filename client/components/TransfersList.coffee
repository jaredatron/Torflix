Putio = require '../Putio'
component = require 'reactatron/component'
styledComponent = require 'reactatron/styledComponent'

Text    = require 'reactatron/Text'
SublteText    = require 'reactatron/SublteText'
Block   = require 'reactatron/Block'
Columns = require 'reactatron/Columns'
Rows    = require 'reactatron/Rows'
Link    = require 'reactatron/Link'
Button  = require 'reactatron/Button'

{progress} = require 'reactatron/DOM'

module.exports = component 'TransfersList',

  propTypes:
    transfers: component.PropTypes.any

  render: ->
    Rows @cloneProps(), @renderTransfers()

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


