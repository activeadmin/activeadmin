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
    numChecked = @checkboxes.filter(':checked').length

    allChecked = numChecked == @checkboxes.length
    someChecked = numChecked > 0 && numChecked < @checkboxes.length

    @toggle_all_checkbox.prop checked: allChecked, indeterminate: someChecked

  _didChangeToggleAllCheckbox: ->
    setting = @toggle_all_checkbox.prop 'checked'
    @checkboxes.prop checked: setting
    setting

  option: (key, value) ->
    if $.isPlainObject(key)
      @options = $.extend(true, @options, key)
    else if key?
      @options[key]
    else
      @options[key] = value

$.widget.bridge 'checkboxToggler', ActiveAdmin.CheckboxToggler
