#= require jquery
#= require react
#= require components
#= require_tree .
#= require_self

getTokenFromHash = ->
  if matches = location.hash.match(/^#access_token=(.*)$/)
    location.hash = null
    session('put_io_access_token', matches[1])


$ ->
  React.render(DOM.App(), document.body)