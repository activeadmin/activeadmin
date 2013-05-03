reindexSort = ($context, inputName)->
  $sortInputs = $("input[name$='#{inputName}']", $context)
  $sortInputs.each (index)->
    $(@).val(index)

$('.has_many.sortable').each ->
  $hasMany  = $(@)
  inputName = $hasMany.attr('data-sortable-input')

  $("li[id$='#{inputName}']", $hasMany).hide()
  reindexSort($hasMany, inputName)

  $(@).sortable
    items: 'fieldset',
    handle: '.handle',
    update: (event, ui)->
      reindexSort($hasMany, inputName)
