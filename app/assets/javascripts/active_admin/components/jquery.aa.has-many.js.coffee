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

    if @sortableInputName = @$container.data('hasManySortableInput')
      @sortableInputSel = ":input[name$='[#{@sortableInputName}]']"
      @$fieldsetContainer.find(@sortableInputSel).hide()


  _bind: ->
    @$container.on 'click', '.has_many_add', () =>
      @addFieldset()
      false

    @$container.on 'click', '.has_many_delete', (event) =>
      fieldset = $(event.target).closest('.has_many_fields')
      @removeFieldset(fieldset)
      false

    if @sortableInputName
      @$fieldsetContainer.sortable({
        items: '> .has_many_fields',
        stop: (event, ui) =>
          @recomputePositions()
      })

      @$fieldsetContainer.on 'change', '[name$="[_destroy]"]', (event) =>
        @recomputePositions()


  addFieldset: ->
    re = new RegExp(@templatePlaceholder, 'g')
    html = @templateHtml.replace(re, new Date().getTime())
    $fieldset = $(html)

    @$fieldsetContainer.append($fieldset)
    @recomputePositions()
    $fieldset.find(@sortableInputSel).hide()
    @$container.trigger('fieldsAdded', $fieldset)


  removeFieldset: (fieldset) ->
    fieldset.remove()
    @recomputePositions()
    @$container.trigger('fieldsRemoved', fieldset)


  recomputePositions: ->
    position = 0
    
    @$fieldsetContainer.children('.has_many_fields').each (index, el)=>
      $fieldset = $(el)
      $destroy = $fieldset.find(':input[name$="[_destroy]"]')
      $sortableInput = $fieldset.find(@sortableInputSel);

      if $destroy.is(':checked')
        $sortableInput.val('')
      else
        $sortableInput.val(position++)

jQuery ($)->
  $.widget.bridge 'hasMany', ActiveAdmin.HasMany
