#= require_self
#= require_tree ./components

@DOM = Object.create(React.DOM)

@component = (name, spec) ->
  spec ||= {}
  spec.displayName = name
  DOM[name] = React.createFactory React.createClass(spec)