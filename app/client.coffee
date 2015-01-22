global.SERVER = false
global.CLIENT = true


React = require 'react'
App   = require './app'

# DEBUGGING
global.require = require
global.React = React

App.getTokenFromHash()

React.render(App(), document.body)

addEventListener "beforeunload", ->
  document.body.innerHTML = ''
  undefined


addEventListener "error", (error) ->
  # consider rendering a blue screen here
  # alert("ERROR: #{error}")
