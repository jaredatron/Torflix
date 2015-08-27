require 'stdlibjs/Object.assign'
require 'stdlibjs/Array#find'
require './client/debug'

app = require './client/app'

require('domready') ->
  app.start()

# React = require 'react'
# component = require 'reactatron/component'
# {div} = React.DOM

# a = component

#   getInitialState: ->
#     console.log('getInitialState', @props.name)
#     {}

#   componentWillMount: ->
#     console.log('componentWillMount', @props.name)

#   componentDidMount: ->
#     console.log('componentDidMount', @props.name)

#   componentWillReceiveProps: ->
#     console.log('componentWillReceiveProps', @props.name)

#   componentWillUpdate: ->
#     console.log('componentWillUpdate', @props.name)

#   render: ->
#     console.log('render', @props.name)
#     div
#       style:
#         border: '1px solid black'
#         padding: '1px'
#       div null, "#{@props.name}: "
#       @props.children

# instance = (
#   a name: '0',
#     a name: '0.0',
#       a name: '0.0.0',
#       a name: '0.0.1',
#     a name: '0.1',
#       a name: '0.1.0',
#       a name: '0.1.1',
#     a name: '0.2',
#     a name: '0.3',
#       a name: '0.3.0',
#         a name: '0.3.0.0',
#           a name: '0.3.0.0.0',
# );

# React.render(instance, document.body)
