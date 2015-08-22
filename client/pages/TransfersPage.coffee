component = require 'reactatron/component'
{div, h1, a} = require 'reactatron/DOM'
TransfersList = require '../components/TransfersList'
# ReactPromptMixin = require '../???'

module.exports = component 'TransfersPage',

  # mixins: [ReactPromptMixin]

  getDataBindings: ->
    ['transfers']

  componentDidMount: ->
    @app.putio.transfers.load()

  render: ->
    div
      className: 'TransfersPage'
      div null, 'TRANSFERS PAGE'
      div null, 'path:',   JSON.stringify(@props.path)
      div null, 'params:', JSON.stringify(@props.params)
      div null, 'transfers:', JSON.stringify(@data.transfers)
      TransfersList
        transfers: @data.transfers


