# `serializeArray` generates => [{ name: 'foo', value: 'bar' }]
# This function remaps it to => { foo: 'bar' }
$.fn.serializeObject = ->
  obj = {}
  for o in @serializeArray()
    obj[o.name] = o.value
  obj
