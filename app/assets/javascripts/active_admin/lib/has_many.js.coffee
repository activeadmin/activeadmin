$ ->
  # Provides a before-removal hook:
  # $ ->
  #   # This is a good place to tear down JS plugins to prevent memory leaks.
  #   $(document).on 'has_many_remove:before', '.has_many_container', (e, fieldset)->
  #     fieldset.find('.select2').select2 'destroy'
  #
  $(document).on 'click', 'a.button.has_many_remove', (e)->
    e.preventDefault()
    parent    = $(@).closest '.has_many_container'
    to_remove = $(@).closest 'fieldset'

    parent.trigger 'has_many_remove:before', [ to_remove ]
    toggle_remove to_remove, true
    recompute_positions parent

  # Provides before and after creation hooks:
  # $ ->
  #   # The before hook allows you to prevent the creation of new records.
  #   $(document).on 'has_many_add:before', '.has_many_container', (e)->
  #     if $(@).children('fieldset').length >= 3
  #       alert "you've reached the maximum number of items"
  #       e.preventDefault()
  #
  #   # The after hook is a good place to initialize JS plugins and the like.
  #   $(document).on 'has_many_add:after', '.has_many_container', (e, fieldset)->
  #     fieldset.find('select').chosen()
  #
  $(document).on 'click', 'a.button.has_many_add', (e)->
    e.preventDefault()
    elem   = $(@)
    parent = elem.closest '.has_many_container'
    parent.trigger before_add = $.Event 'has_many_add:before'

    unless before_add.isDefaultPrevented()
      index = parent.data('has_many_index') || parent.children('fieldset').length - 1
      parent.data has_many_index: ++index

      regex = new RegExp elem.data('placeholder'), 'g'
      html  = elem.data('html').replace regex, index

      fieldset = $(html).insertBefore(elem.parent()).addClass('has_many_new')
      recompute_positions parent
      parent.trigger 'has_many_add:after', [ fieldset ]

  $(document).on 'click', 'a.button.has_many_undo_remove', (e) ->
    e.preventDefault()
    return if $(@).hasClass 'disabled'
    parent = $(@).closest '.has_many_container'
    $to_unremove = last_removed parent

    if $to_unremove?
      toggle_remove $to_unremove, false
      parent.trigger 'has_many_add:after', [ $to_unremove ]
      recompute_positions parent

  $(document).on 'change','.has_many_container[data-sortable] :input[name$="[_destroy]"]', ->
    recompute_positions $(@).closest '.has_many'

  init_sortable()
  $(document).on 'has_many_add:after', '.has_many_container', init_sortable

  $(document).on 'submit', 'form', (e) ->
    # Clean the form of all removed new nested records
    $('.has_many_new.has_many_removed').remove()


# Helpers
init_sortable = ->
  elems = $('.has_many_container[data-sortable]:not(.ui-sortable)')
  elems.sortable \
    items: '> fieldset',
    handle: '> ol > .handle',
    stop:    recompute_positions
  elems.each recompute_positions

recompute_positions = (parent)->
  parent     = if parent instanceof jQuery then parent else $(@)
  input_name = parent.data 'sortable'
  position   = 0

  parent.children('fieldset').each ->
    fieldset = $(@)
    # when looking for inputs, we ignore inputs from the possibly nested inputs
    # so, when defining your has_many, make sure to keep the sortable input at the root of the has_many block
    destroy_input  = fieldset.find "> ol > .input > :input[name$='[_destroy]']"
    sortable_input = fieldset.find "> ol > .input > :input[name$='[#{input_name}]']"

    if sortable_input.length
      sortable_input.val if fieldset.hasClass('has_many_removed') then '' else position++

last_removed = (parent) ->
  sorted_removed = parent.children('fieldset.has_many_removed').sort (a, b) ->
    $(b).data('has_many_removed_index') - $(a).data('has_many_removed_index')
  $ sorted_removed[0]

toggle_remove = ($item, remove) ->
  $item         = if $item instanceof jQuery then $item else $(@)
  $parent       = $item.closest '.has_many_container'
  destroy_input = $item.find '> ol > .input > :input[name$="[_destroy]"]'

  if remove
    $last_removed = last_removed $parent
    index = if $last_removed? then $last_removed.data('has_many_removed_index') + 1 else 1
    $item.data 'has_many_removed_index', index
  else
    index = $item.data('has_many_removed_index') - 1
    $item.removeData 'has_many_removed_index'

  destroy_input.attr 'value', remove if destroy_input.length
  $item.toggleClass 'has_many_removed', remove

  $parent.find('.button.has_many_undo_remove').toggleClass 'disabled', !index
