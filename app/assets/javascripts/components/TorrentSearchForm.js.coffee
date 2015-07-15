#= require 'PromiseStateMachine'
#= require 'Torrent'

component 'TorrentSearchForm',
  
  render: ->
    {div, Form} = DOM
    Form(
      className: 'TorrentSearchForm'
      DOM.input
        ref: 'input'
    )