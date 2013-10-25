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
      @sortFields()


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


  # sort the fields to match their positions
  sortFields: ->
    $fields = @$fieldsetContainer.children('.has_many_fields')
    # sort the fields in memory
    fieldsWithPosition = []
    $fields.each (index, el) =>
      position = parseInt $(@sortableInputSel, el).val() || "#{index + $fields.length}"
      fieldsWithPosition.push [el, position]

    outOfOrder = false

    fieldsWithPosition = fieldsWithPosition.sort (a, b) ->
      c = a[1] - b[1]
      outOfOrder = true if c < 0
      c

    # sort in the DOM only if necessary
    if outOfOrder
      for [el, position] in fieldsWithPosition
        @$fieldsetContainer.append el


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
