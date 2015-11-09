root = exports ? this
class GlobalBroadcaster
  subscribers = {}
  subscribe: (event, callback) ->
    subscribers[event] ||= []
    subscribers[event].push(callback)
  emit: (event, params) ->
    subscribers[event] ||= []
    for sub in subscribers[event]
      sub(params)
root.globalBroadcaster = new GlobalBroadcaster()
