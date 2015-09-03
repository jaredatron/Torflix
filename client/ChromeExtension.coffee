require 'stdlibjs/Function#defer'
require 'stdlibjs/Function#delay'
DOMEventMessageBus = require 'dom-event-message-bus'

TIMEOUT =  1 * 1000 # 1 second

messageBus = new DOMEventMessageBus
  name:         'CLIENT'
  color:        'purple'
  DOMNode:       document
  sendEvent:    'toChromeExtension'
  receiveEvent: 'fromChromeExtension'

messageBus.onReceiveMessage = (message) ->
  switch message.type
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
      timeoutId = timeout.delay(TIMEOUT)

      callback = (response) ->
        clearTimeout(timeoutId)
        resolve(response)

      queuedMessages.push [type, payload, callback]


resolveQueuedMessages = ->
  while queuedMessages.length
    [type, payload, callback] = queuedMessages.shift()
    callback(messageBus.sendMessage(type, payload))






HTTP_REQUEST_TIMEOUT = 4 * 1000 # 4 seconds
requests = []
lastRequestId = 0;
HTTPRequest = (request) ->
  request.id = lastRequestId++
  requests.push(request)
  return sendMessageAsync('HTTPRequest', request).then (callbackEvent) ->
    new Promise (resolve, reject) ->
      timeout = ->
        error = "HTTPRequest #{request.id} timed out"
        reject({error, request})
      timeoutId = timeout.delay(HTTP_REQUEST_TIMEOUT)

      messageBus.onNext callbackEvent, (response) ->
        clearTimeout(timeoutId)
        resolve(response)






# sendMessageAsync('echo', 'A')
#   .then (r) -> console.info('echo A', r)
#   .catch (e) -> console.error(e)

# sendMessageAsync('echo', 'B')
#   .then (r) -> console.info('echo B', r)
#   .catch (e) -> console.error(e)


# request(url: 'https://www.google.com/search?q=ass')
#   .then  (r) -> console.info('HTTPResponse?', r)
#   .catch (e) -> console.error(e)

module.exports = ChromeExtension =
  messageBus:     messageBus
  queuedMessages: queuedMessages
  sendMessage:    sendMessageAsync
  HTTPRequest:    HTTPRequest

