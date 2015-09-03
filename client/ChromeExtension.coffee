

sendMessage = (message) ->
  document.dispatchEvent(new CustomEvent('ToTorflixChromeExtension', {detail:message}))

receiveMessage = (message) ->
  # console.log('From ChromeExtension:', message)
  MessageHandlers[message.type](message)


document.addEventListener 'ToTorflix', (event) ->
  receiveMessage(event.detail)

MessageHandlers =

  ping: (message) ->
    sendMessage({type: 'pong'})

  pong: (message) ->
    console.log('ping to ToTorflixChromeExtension successful')

  requestResponse: (message) ->
    {response} = message
    {request} = response
    callback = requestCallbacks[request.__id]
    delete requestCallbacks[request.__id]
    callback(response)


nextRequestId = -> nextRequestId.i++
nextRequestId.i = 0

requestCallbacks = {}
request = (request, callback) ->
  id = nextRequestId()
  request.__id = id
  requestCallbacks[id] = callback
  sendMessage
    type: 'request'
    request: request

module.exports =
  sendMessage: sendMessage
  request: request


