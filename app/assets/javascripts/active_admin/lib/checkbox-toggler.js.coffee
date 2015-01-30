class ActiveAdmin.CheckboxToggler
  constructor: (@options, @container)->
    defaults = {}
    @options = $.extend defaults, @options
    @_init()
    @_bind()

  _init: ->
    if not @container
      throw new Error('Container element not found')
    else
      @$container = $(@container)

    if not @$container.find('.toggle_all').length
      throw new Error('"toggle all" checkbox not found')
    else
      @toggle_all_checkbox = @$container.find '.toggle_all'

    @checkboxes = @$container.find(':checkbox').not @toggle_all_checkbox

  _bind: ->
    @checkboxes.change       (e)=> @_didChangeCheckbox e.target
    @toggle_all_checkbox.change => @_didChangeToggleAllCheckbox()

  _didChangeCheckbox: (checkbox)->
    switch @checkboxes.filter(':checked').length
      when @checkboxes.length - 1 then @toggle_all_checkbox.prop checked: null
      when @checkboxes.length     then @toggle_all_checkbox.prop checked: true

  _didChangeToggleAllCheckbox: ->
    setting = if @toggle_all_checkbox.prop 'checked' then true else null
    @checkboxes.each (index, el)=>
      $(el).prop checked: setting
      @_didChangeCheckbox(el)

$.widget.bridge 'checkboxToggler', ActiveAdmin.CheckboxToggler
