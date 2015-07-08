#= require jquery
#= require react
#= require components
#= require_tree .
#= require_self

$ ->
  React.render(DOM.App(), document.body)