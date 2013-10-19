# @TODO test!, remove unnecessary conversions, etc..
define ['lodash', 'Uri'], (_, Uri) ->
  currentUserTime = (clock, interval) ->
    if not _.isFinite(interval)
      interval = 1000*60

    updateClock = ->
      clock((new Date()).getHours())

    setInterval(updateClock, interval)

  ({clock, clockFn, interval, customUrl}) ->
    if _.isFunction(clockFn)
      setFunctionClock = ->
        clockFn(clock)
      setTimeout(setFunctionClock, 0)
    else
      if _.isString(customUrl)
        uri =  new Uri(customUrl)
      else
        uri =  new Uri(window.location)
      hashClock = parseInt uri.setQuery(uri.anchor()).getQueryParamValues('clock')

    if _.isFinite hashClock
      setHashClock = ->
        clock(hashClock)
      setTimeout(setHashClock, 0)
    else
      currentUserTime(clock, interval)


