console.warn 'DEBUG object loaded'
React = require 'react/addons'
ReactElement = require 'react/lib/ReactElement'
URI = require 'URIjs'

app = require './app'


app.stats.fileRerenders = 0


logEvent = (event, payload) ->
  console.log('Event', event, payload)

logAllEvents = ->
  app.sub '*', logEvent
logAllEvents()

stopLoggingAllEvents = ->
  app.unsub '*', logEvent


warnBeforePageUnload = ->
  window.addEventListener "beforeunload", (event) ->
    debugger
    event.returnValue = "Should this have been a page unload?"


getStats = ->
  Object.assign({}, app.stats, app.store.stats)

loggingStatChanges = false
startLoggingStatChanges = ->
  loggingStatChanges = true
  prevStats = getStats()
  timeLastFrameEnded = Date.now()
  logStats = ->
    return unless loggingStatChanges
    now = Date.now()
    setTimeout(logStats)
    currStats = getStats()
    changes = {}
    for key, value of currStats
      delta = currStats[key] - prevStats[key]
      changes[key] = delta if delta > 0
    if Object.keys(changes).length > 0
      prevStats = Object.clone(currStats)
      changes.numberOfDomNodes = document.body.querySelectorAll('*').length
      duration = now-timeLastFrameEnded
      args = ["FRAME: #{duration}ms", changes]
      switch
        when duration > 1000
          console.error(args...)
        when duration > 500
          console.warn(args...)
        else
          console.info(args...)
    timeLastFrameEnded = now

  setTimeout(logStats)

stopLoggingStatChanges = ->
  loggingStatChanges = false


clearLocalStorage = ->
  delete localStorage[key] for key of localStorage


reset = ->
  clearLocalStorage()
  location.reload()



DEBUG = {};

DEBUG.React = React
DEBUG.URI = URI
DEBUG.app = app
DEBUG.ReactElement = require 'react/lib/ReactElement'
# DEBUG.animator = require './animator'
DEBUG.Style = require 'reactatron/Style'
DEBUG.Box   = require 'reactatron/Box'
DEBUG.Block = require 'reactatron/Block'
DEBUG.Rows  = require 'reactatron/Rows'

DEBUG.isElement                           = React.addons.TestUtils.isElement
DEBUG.isElementOfType                     = React.addons.TestUtils.isElementOfType
DEBUG.isDOMComponent                      = React.addons.TestUtils.isDOMComponent
DEBUG.isDOMComponentElement               = React.addons.TestUtils.isDOMComponentElement
DEBUG.isCompositeComponent                = React.addons.TestUtils.isCompositeComponent
DEBUG.isCompositeComponentWithType        = React.addons.TestUtils.isCompositeComponentWithType
DEBUG.isCompositeComponentElement         = React.addons.TestUtils.isCompositeComponentElement
DEBUG.isCompositeComponentElementWithType = React.addons.TestUtils.isCompositeComponentElementWithType

DEBUG.reset                = reset
DEBUG.clearLocalStorage    = clearLocalStorage
DEBUG.warnBeforePageUnload = warnBeforePageUnload
DEBUG.logAllEvents         = logAllEvents
DEBUG.stopLoggingAllEvents = stopLoggingAllEvents

# Globals

global.DEBUG = DEBUG
global.log  = console.log.bind(console)
global.warn = console.warn.bind(console)


startLoggingStatChanges()
