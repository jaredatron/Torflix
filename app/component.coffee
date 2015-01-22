React = require 'react'

module.exports = (name, spec) ->
  spec.displayName = name
  React.createFactory React.createClass(spec)

