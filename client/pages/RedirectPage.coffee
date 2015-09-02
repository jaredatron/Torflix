component = require 'reactatron/component'
Block = require 'reactatron/Block'
Layout = require '../components/Layout'

module.exports = component 'RedirectPage',
  render: ->
    Layout {},
      Block {}, "Redecting to #{@props.location} !!!!! >D"
