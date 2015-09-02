console.warn 'DEBUG object loaded'
React = require 'react/addons'
ReactElement = require 'react/lib/ReactElement'
URI = require 'URIjs'

app = require './app'


app.stats.fileRerenders = 0


logEvent = (event, payload) ->
  console.log('Event', event, payload)

logAllEvents = ->
  localStorage.logAllEvents = true
  app.sub '*', logEvent

stopLoggingAllEvents = ->
  localStorage.logAllEvents = false
  app.unsub '*', logEvent

logAllEvents() if localStorage.logAllEvents


warnBeforePageUnload = ->
  window.addEventListener "beforeunload", (event) ->
    debugger
    event.returnValue = "Should this have been a page unload?"


getStats = ->
  Object.assign({}, app.stats, app.store.stats)


logFrameData = ->
  localStorage.logStateChanges = true
  prevStats = getStats()
  timeLastFrameEnded = Date.now()
  logStats = ->
    return unless localStorage.logStateChanges
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

      rendered = (
        'componentsInitialized' of changes ||
        'componentsMounted'     of changes ||
        'componentsUnmounted'   of changes ||
        'componentsUpdated'     of changes
      )


      duration = now-timeLastFrameEnded


      # if rendered
      #   color = switch
      #     when duration > 1000 then 'red'
      #     when duration > 500  then 'orange'
      #     when duration > 200  then 'black'
      #     else                      'green'
      #   console.log "%cRENDER #{duration}ms ", "color: #{color}; font-size: 110%; "

      # if duration > 200
      #   console.log "%cSLOW FRAME #{duration}ms ", "color: red; font-size: 120%; "
      #   console.dir(changes)

      message = "%cFRAME #{duration}ms"
      message += ' RENDER' if rendered
      style = "font-size: 120%; "

      style += switch
        when duration > 1000 then 'color: red; '
        when duration > 500  then 'color: orange; '
        when duration > 200  then 'color: black; '
        else                      'color: green; '

      console.log(message, style)
    timeLastFrameEnded = now

  setTimeout(logStats)

stopLogginFrameData = ->
  delete localStorage.logStateChanges

logFrameData() if localStorage.logStateChanges


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
DEBUG.logFrameData         = logFrameData
DEBUG.stopLogginFrameData  = stopLogginFrameData

# Globals

global.DEBUG = DEBUG
global.log  = console.log.bind(console)
global.warn = console.warn.bind(console)
