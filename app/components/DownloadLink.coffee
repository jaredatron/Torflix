React     = require 'react'
component = require '../component'
assign    = require('object-assign')

{a} = React.DOM

module.exports = component 'DownloadLink',

  propTypes:
    href: React.PropTypes.string.isRequired

  onClick: (event) ->
    event.preventDefault()

  render: ->
    props = assign({}, @props)
    props.href = @props.href || ''
    props.download = true
    a(props)
