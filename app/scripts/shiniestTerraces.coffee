#@TODO testing.
define ['knockout'], (ko) ->
  (points) ->
    ko.computed ->
      sortFunction = (point) ->
        multiplierFunctor = (acc) ->
          acc*10

        levels = _.pluck(point.shine, 'level')
        multipliers = _.map(_.range(5), (multiplier) -> _.reduce(_.times(multiplier), multiplierFunctor, 1)).reverse()

        _.merge levels, multipliers, (a, b) -> a*b

      _.sortBy(points(), sortFunction).reverse()