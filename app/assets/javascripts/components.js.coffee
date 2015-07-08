#= require_self
#= require_tree ./components

@DOM = Object.create(React.DOM)

@component = (name, spec) ->
  if ('string' != typeof name)
    spec = name
    name = null
  spec ||= {}
  spec.displayName = name if name?
  component = React.createClass(spec)
  componentFactory = React.createFactory(component)
  componentFactory.component = component
  DOM[name] = componentFactory if name?
  componentFactory