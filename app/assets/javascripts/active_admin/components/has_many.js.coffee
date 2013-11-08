$ ->
  # Provides a before-removal hook:
  # $ ->
  #   # This is a good place to tear down JS plugins to prevent memory leaks.
  #   $(document).on 'has_many_remove:before', '.has_many', (e, fieldset)->
  #     fieldset.find('.select2').select2 'destroy'
  #
  $(document).on 'click', 'a.button.has_many_remove', (e)->
    e.preventDefault()
    parent    = $(@).closest '.has_many'
    to_remove = $(@).closest 'fieldset'

    parent.trigger 'has_many_remove:before', [ to_remove ]
    to_remove.remove()

  # Provides before and after creation hooks:
  # $ ->
  #   # The before hook allows you to prevent the creation of new records.
  #   $(document).on 'has_many_add:before', '.has_many', (e)->
  #     if $(@).children('fieldset').length >= 3
  #       alert "you've reached the maximum number of items"
  #       e.preventDefault()
  #
  #   # The after hook is a good place to initialize JS plugins and the like.
  #   $(document).on 'has_many_add:after', '.has_many', (e, fieldset)->
  #     fieldset.find('select').chosen()
  #
  $(document).on 'click', 'a.button.has_many_add', (e)->
    e.preventDefault()
    elem   = $(@)
    parent = elem.closest '.has_many'
    parent.trigger before_add = $.Event 'has_many_add:before'

    unless before_add.isDefaultPrevented()
      # because FormBuilder's `has_many` method can render/add fieldsets that may
      # be nested in an `inputs` block, we need to account for both situations
      # when calculating the has_many_index.
      index = parent.data('has_many_index') || parent.children('fieldset.has_many_fields').length + parent.find('> li > fieldset.has_many_fields').length - 1
      parent.data has_many_index: ++index

      regex = new RegExp elem.data('placeholder'), 'g'
      html  = elem.data('html').replace regex, index

      parent.trigger 'has_many_add:after', [ $(html).insertBefore(@) ]
