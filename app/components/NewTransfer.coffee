React     = require 'react'
component = require '../component'

{div, form, input, button} = React.DOM

module.exports = component 'NewTransfer',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  getInitialState: ->
    link: ''

  onChange: (event) ->
    @setState link: event.target.value

  onSubmit: (event) ->
    event.preventDefault()
    @context.putio.transfers.add @state.link
    @setState link: ''


  render: ->
    form
      className: 'NewTransfer'
      onSubmit: @onSubmit
      input
        ref: 'link'
        type: 'text'
        placeholder: 'paste torrent link here'
        value: @state.link
        onChange: @onChange
      input
        type: 'submit'
        value: 'add'

