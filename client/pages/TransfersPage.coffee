component = require 'reactatron/component'
{div, h1, a} = require 'reactatron/DOM'
TransfersList = require '../components/TransfersList'
# ReactPromptMixin = require '../???'

module.exports = component 'TransfersPage',

  # mixins: [ReactPromptMixin]

  render: ->
    div
      className: 'TransfersPage'
      h1 null, 'Transfers Page'
      TransfersList()
      # @renderPrompt()

