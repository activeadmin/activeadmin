window.ActiveAdmin.HasMany = class ActiveAdmin.HasMany
  constructor: (@options, @container)->
    defaults = {}
    @options = $.extend {}, defaults, options
    @_init()
    @_bind()

  _init: ->
    if not @container
      throw new Error('Container element not found')
    else
      @$container = $(@container)

    @$template = @$container.find('.has_many_template')
    @templateHtml = @$template.html()
    @templatePlaceholder = @$template.data('placeholder')

    @$fieldsetContainer = @$container.children('.input:eq(0)')

  _bind: ->
    @$container.on 'click', '.has_many_add', () =>
      @addFieldset()
      false

    @$container.on 'click', '.has_many_delete', (event) =>
      fieldset = $(event.target).closest('.has_many_fields')
      @removeFieldset(fieldset)
      false

  addFieldset: ->
    re = new RegExp(@templatePlaceholder, 'g')
    html = @templateHtml.replace(re, new Date().getTime())

    @$fieldsetContainer.append(html)

  removeFieldset: (fieldset) ->
    fieldset.remove()

jQuery ($)->
  $.widget.bridge 'hasMany', ActiveAdmin.HasMany
