React = require 'reactatron/React'
URI = require 'URIjs'
app = require './app'


app.stats.fileRerenders = 0


logEvent = (event, payload) ->
  console.log('Event', event, payload)

logAllEvents = ->
  localStorage.logAllEvents = true
  app.sub '*', logEvent

stopLoggingAllEvents = ->
  delete localStorage.logAllEvents
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
      style = "font-size: 100%; "

      style += switch
        when duration > 1000 then 'color: red; '
        when duration > 500  then 'color: orange; '
        when duration > 200  then 'color: black; '
        else                      'color: green; '

      console.log(message, style)
      console.log(changes)

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



D = {};

D.React = React
D.URI = URI
D.app = app
# D.animator = require './animator'
D.$ = require 'jquery'
D.Style = require 'reactatron/Style'
D.Box   = require 'reactatron/Box'
D.Block = require 'reactatron/Block'
D.Rows  = require 'reactatron/Rows'

if React.addons.TestUtils
  D.isElement                           = React.addons.TestUtils.isElement
  D.isElementOfType                     = React.addons.TestUtils.isElementOfType
  D.isDOMComponent                      = React.addons.TestUtils.isDOMComponent
  D.isDOMComponentElement               = React.addons.TestUtils.isDOMComponentElement
  D.isCompositeComponent                = React.addons.TestUtils.isCompositeComponent
  D.isCompositeComponentWithType        = React.addons.TestUtils.isCompositeComponentWithType
  D.isCompositeComponentElement         = React.addons.TestUtils.isCompositeComponentElement
  D.isCompositeComponentElementWithType = React.addons.TestUtils.isCompositeComponentElementWithType

D.reset                = reset
D.clearLocalStorage    = clearLocalStorage
D.warnBeforePageUnload = warnBeforePageUnload
D.logAllEvents         = logAllEvents
D.stopLoggingAllEvents = stopLoggingAllEvents
D.logFrameData         = logFrameData
D.stopLogginFrameData  = stopLogginFrameData

# Globals

global.D = D

global.log  = console.log.bind(console)
global.warn = console.warn.bind(console)
global.logger = (prefix) ->
  console.log.bind(console, prefix)

global.request = require './request'
