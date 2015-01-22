global.SERVER = false
global.CLIENT = true


React = require 'react'
App   = require './app'

# DEBUGGING
global.require = require
global.React = React

App.getTokenFromHash()

app = App()
#   pathname: Path.pathname
#   params:   Path.params

# Path.onChange ->
#   app.setState
#     pathname: Path.pathname
#     params:   Path.params

React.render(app, document.body)


addEventListener "beforeunload", ->
  document.body.innerHTML = ''
  undefined
