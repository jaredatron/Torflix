#= require jquery
#= require react
#= require Classnames
#= require components
#= require_self

render = ->
  React.render(DOM.App(), document.body)

$ ->
  Putio.init()
  render()