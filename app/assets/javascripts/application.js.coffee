#= require jquery
#= require react
#= require components
#= require_tree .
#= require_self

getTokenFromHash = ->
  if matches = location.hash.match(/^#access_token=(.*)$/)
    session('put_io_access_token', matches[1])
    location.hash = null

render = ->
  React.render(DOM.App(), document.body)
  
$ ->
  getTokenFromHash()
  render()