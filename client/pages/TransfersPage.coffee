component = require 'reactatron/component'
{div, h1} = require 'reactatron/DOM'
TransfersList = require '../components/TransfersList'
# ReactPromptMixin = require '../???'

module.exports = component 'TransfersPage',

  # mixins: [ReactPromptMixin]

  render: ->
    div
      className: 'TransfersPage'
      TransfersList()
      # @renderPrompt()

