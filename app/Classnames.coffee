Classnames = ->
  if this instanceof Classnames
    this.names = {}
    this.add.apply(this, arguments)
    return this
  else
    classnames = new Classnames
    classnames.add.apply(classnames, arguments)
    return classnames.toString()


Classnames.prototype.add = ->
  i = arguments.length+1
  names = this.names

  while i--
    argument = arguments[i]

    if typeof argument == 'string'
      argument = Classnames.stringToArray(argument)

    if Array.isArray(argument)
      argument.forEach (classname) ->
        names[classname] = true if typeof classname == 'string'

    else
      for p of argument
        names[p] = true if argument[p]

  return this



Classnames.prototype.toString = ->
  Object.keys(this.names).sort().join(' ')

Classnames.stringToArray = (string) ->
  string.replace(/^\s+|\s+$/g,'').split(/\s+/)

module.exports = Classnames
