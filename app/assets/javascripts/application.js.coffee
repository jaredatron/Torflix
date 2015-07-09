#= require jquery
#= require react
#= require components
#= require_self

getTokenFromHash = ->

  if matches = location.hash.match(/^#access_token=(.*)$/)
    session('put_io_access_token', matches[1])
    window.location = location.toString().substring(0, location.href.indexOf('#'))

render = ->
  React.render(DOM.App(), document.body)

$ ->
  getTokenFromHash()
  render()