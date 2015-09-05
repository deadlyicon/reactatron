require 'shouldhave/Object.bindAll'
require 'shouldhave/Array.wrap'
require 'shouldhave/Array#remove'
require 'shouldhave/Array#includes'
isString = require 'shouldhave/isString'

class Events

  constructor: ->
    Object.bindAll(this)
    @publishingTimeout = null
    @subscriptions = {}
    @publishings = []
    @_clearQueueCallbacks = []

  sub: (events, handler) ->
    events = Array.wrap(events)
    for event in events
      subscriptions = @subscriptions[event] ||= []
      subscriptions.push handler unless subscriptions.includes handler
    this

  unsub: (events, handler) ->
    events = Array.wrap(events)
    for event in events
      if subscriptions = @subscriptions[event]
        subscriptions.remove(handler)
        if subscriptions.length == 0
          delete @subscriptions[event]
    this

  onNext: (events, originalHandler) ->
    unsub = @unsub
    handler = ->
      unsub(events, handler)
      originalHandler.apply(this, arguments)
    @sub(events, handler)

  pub: (event, payload, done) ->
    @_schedulePublishing(event, payload, done)
    this


  waitForClearQueue: (callback) ->
    @_clearQueueCallbacks.push callback
    @_schedulePublish()

  _schedulePublish: ->
    @publishingTimeout ||= setTimeout(@_publish)

  _schedulePublishing: (event, payload, done) ->
    @publishings.push [event, payload, done]
    @_schedulePublish()


  _publish: ->
    clearTimeout(@publishingTimeout) if @publishingTimeout?
    @publishingTimeout = null

    publishings = @publishings
    @publishings = []

    keys = publishings.map (p) -> p[0]

    # doneCallbacks = []
    calls = []
    for [event, payload, done] in publishings
      subscriptions = @subscriptions[event] || []
      subscriptions = subscriptions.concat(@subscriptions['*'] || [])
      for handler in subscriptions
        calls.push [handler, [event, payload]]

      # calls.push [done, [event, payload]] if done
      @_clearQueueCallbacks.push done if done

    # call all subscribed callbacks
    for [callback, args] in calls
      callback.apply(null, args)

    if @publishings.length == 0
      calls = []
      while @_clearQueueCallbacks.length > 0
        @_clearQueueCallbacks.shift()()

    this


module.exports = Events
