$ ->
  # Provides a before-removal hook:
  # $ ->
  #   # This is a good place to tear down JS plugins to prevent memory leaks.
  #   $(document).on 'has_many_remove:before', '.has_many_container', (e, fieldset, container)->
  #     fieldset.find('.select2').select2 'destroy'
  #
  #   # If you need to do anything after removing the items you can use the
  #   has_many_remove:after hook
  #   $(document).on 'has_many_remove:after', '.has_many_container', (e, fieldset, container)->
  #     list_item_count = container.find('.has_many_fields').length
  #     alert("There are now #{list_item_count} items in the list")
  #
  $(document).on 'click', 'a.button.has_many_remove', (e)->
    e.preventDefault()
    parent    = $(@).closest '.has_many_container'
    to_remove = $(@).closest 'fieldset'
    recompute_positions parent

    parent.trigger 'has_many_remove:before', [to_remove, parent]
    to_remove.remove()
    parent.trigger 'has_many_remove:after', [to_remove, parent]

  # Provides before and after creation hooks:
  # $ ->
  #   # The before hook allows you to prevent the creation of new records.
  #   $(document).on 'has_many_add:before', '.has_many_container', (e, container)->
  #     if $(@).children('fieldset').length >= 3
  #       alert "you've reached the maximum number of items"
  #       e.preventDefault()
  #
  #   # The after hook is a good place to initialize JS plugins and the like.
  #   $(document).on 'has_many_add:after', '.has_many_container', (e, fieldset, container)->
  #     fieldset.find('select').chosen()
  #
  $(document).on 'click', 'a.button.has_many_add', (e)->
    e.preventDefault()
    parent = $(@).closest '.has_many_container'
    parent.trigger before_add = $.Event('has_many_add:before'), [parent]

    unless before_add.isDefaultPrevented()
      index = parent.data('has_many_index') || parent.children('fieldset').length - 1
      parent.data has_many_index: ++index

      regex = new RegExp $(@).data('placeholder'), 'g'
      html  = $(@).data('html').replace regex, index

      fieldset = $(html).insertBefore(@)
      recompute_positions parent
      parent.trigger 'has_many_add:after', [fieldset, parent]

  $(document).on 'change','.has_many_container[data-sortable] :input[name$="[_destroy]"]', ->
    recompute_positions $(@).closest '.has_many'

  init_sortable()
  $(document).on 'has_many_add:after', '.has_many_container', init_sortable


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
  position   = parseInt(parent.data('sortable-start') || 0, 10)

  parent.children('fieldset').each ->
    # We ignore nested inputs, so when defining your has_many, be sure to keep
    # your sortable input at the root of the has_many block.
    destroy_input  = $(@).find "> ol > .input > :input[name$='[_destroy]']"
    sortable_input = $(@).find "> ol > .input > :input[name$='[#{input_name}]']"

    if sortable_input.length
      sortable_input.val if destroy_input.is ':checked' then '' else position++
