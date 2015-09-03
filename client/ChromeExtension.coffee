require 'stdlibjs/Function#defer'
require 'stdlibjs/Function#delay'
DOMEventMessageBus = require 'dom-event-message-bus'



messageBus = new DOMEventMessageBus
  name:         'CLIENT'
  color:        'purple'
  DOMNode:       document
  sendEvent:    'toChromeExtension'
  receiveEvent: 'fromChromeExtension'

messageBus.onReceiveMessage = ({id, type, payload}) ->
  switch type
    when 'ready'
      onReady.defer()

  return null


onReady = ->
  messageBus.log('ChromeExtension ready')
  resolveQueuedMessages()


queuedMessages = []
sendMessageAsync = (type, payload) ->
  new Promise (resolve, reject) =>
    if messageBus.isReady()
      resolve(messageBus.sendMessage(type, payload))
    else
      timeout = ->
        error = 'Timedout talking to ChromeExtension'
        reject({error, type, payload})
      timeoutId = timeout.delay(500)

      callback = (response) ->
        clearTimeout(timeoutId)
        resolve(response)
      queuedMessages.push [type, payload, callback]


resolveQueuedMessages = ->
  console.info('queuedMessages', queuedMessages)
  while queuedMessages.length
    [type, payload, callback] = queuedMessages.shift()
    callback(messageBus.sendMessage(type, payload))












sendMessageAsync('echo', 'A').then (r) ->
  console.info('echo???', r)
sendMessageAsync('echo', 'B').then (r) ->
  console.info('echo???', r)

module.exports = ChromeExtension =
  messageBus:     messageBus
  queuedMessages: queuedMessages
  sendMessage:    sendMessageAsync





# # require 'stdlibjs/Promise'

# EVENT_PREFIX  = 'TorflixChromeExtension'
# SEND_EVENT    = "#{EVENT_PREFIX}:sendMessage"
# RECEIVE_EVENT = "#{EVENT_PREFIX}:receiveMessage"

# document.addEventListener RECEIVE_EVENT, (event) ->
#   receiveMessage(event.detail)

# dispatchEvent = (event, message) ->
#   document.dispatchEvent(new CustomEvent(event, {detail:message}))

# pendingSentMessages = []
# sendMessage = (message) ->
#   message.id = lastMessageId++
#   dispatchEvent(SEND_EVENT, message)

# receiveMessage = (message) ->
#   # console.log('From ChromeExtension:', message)
#   MessageHandlers[message.type](message)


# MessageHandlers =

#   ping: (message) ->
#     sendMessage({type: 'pong'})

#   pong: (message) ->
#     console.log('ping to ToTorflixChromeExtension successful')

#   loaded: (message) ->
#     console.log("ToTorflixChromeExtension loaded at #{message.loadedAt}")

#   receipt: (message) ->
#     console.info('MESSAGE RECEIPT', message)



#   requestResponse: (message) ->
#     {response} = message
#     {request} = response
#     id = request.chromeExtensionRequestId
#     callback = requestCallbacks[id]
#     delete requestCallbacks[id]
#     callback(response)








#   # lastMessageId = Date.now()
#   # sendMessageReturningPromise = (message) ->
#   #   messge.id = lastMessageId++

#   #   messageRecievedCallback = (event) ->
#   #     console.log('MESSAGE RECIEVED')

#   #   document.addEventListener FROM_EVENT,



#   #   rv = document.dispatchEvent(new CustomEvent(TO_EVENT, {detail:message}))
#   #   console.log('sendMessage rv:', rv)

#   #   return new Promise (resolve, reject) ->











# nextRequestId = -> nextRequestId.i++
# nextRequestId.i = 0

# lastRequestId = -1
# requestCallbacks = {}
# request = (request, callback) ->
#   id = nextRequestId()
#   request.chromeExtensionRequestId = lastRequestId
#   requestCallbacks[id] = callback
#   sendMessage
#     type: 'request'
#     request: request




# module.exports =
#   sendMessage: sendMessage
#   request: request


