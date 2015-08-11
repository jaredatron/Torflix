App.events = {}


App.on (events, callback) ->
  switch typeof events
    when 'string'
      events.split(/\s+/).forEach (event) =>
        if (!event || event == '') return;
        @events[event] ||= []
        @events[event].push(event)

    when 'object'
    else



splitEvents = (events) ->
  events.split(/\s+/)