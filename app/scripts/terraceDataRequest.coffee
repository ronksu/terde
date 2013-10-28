define [
  'jquery'
],(
  $
) ->
  init = ->
    # @TODO add time to url.
    $.ajax
      url: '/data/terassit_0101.json'
      dataType: 'json'

  {init}