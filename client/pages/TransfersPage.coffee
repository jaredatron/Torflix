component = require 'reactatron/component'
{div, h1, a} = require 'reactatron/DOM'
Layout = require '../components/Layout'
TransfersList = require '../components/TransfersList'

module.exports = component 'TransfersPage',

  getDataBindings: ->
    ['transfers']

  componentDidMount: ->
    @app.pub 'reload transfers'

  render: ->
    Layout null,
      div
        className: 'TransfersPage'
        div null, 'TRANSFERS PAGE'
        div null, 'path:',   JSON.stringify(@props.path)
        div null, 'params:', JSON.stringify(@props.params)
        div null, 'transfers:', JSON.stringify(@data.transfers)
        TransfersList
          transfers: @data.transfers


