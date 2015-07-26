#= require 'Array.prototype.find'



Array.prototype.first = () ->
  return this[0]

Array.prototype.last = () ->
  return this[this.length-1]

Array.prototype.includes = (object) ->
  return this.indexOf(object) != -1

String.prototype.includes = (string) ->
  return this.indexOf(string) != -1


