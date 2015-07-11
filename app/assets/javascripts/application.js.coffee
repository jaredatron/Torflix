#= require jquery
#= require react
#= require Classnames
#= require components
#= require_self

getPutioTokenFromHash = ->
  if matches = location.hash.match(/^#access_token=(.*)$/)
    session('put_io_access_token', matches[1])
    window.location = location.toString().substring(0, location.href.indexOf('#'))

getPutioTokenFromHash()
@putio = new Putio(session('put_io_access_token'))

$ -> 
  React.render(DOM.App(), document.body)