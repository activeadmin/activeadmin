window.CheckboxToggler = class CheckboxToggler

  constructor: (@container, @options) ->
    @_init()
    @_bind()
   
  _init: ->
    
    if not @container
      throw new Error("Container element not found")

    if not @container.find(".toggle_all").length
      throw new Error("'toggle all' checkbox not found")
    else
      @toggle_all_checkbox = @container.find(".toggle_all")

    @checkboxes = @container.find(":checkbox").not(@toggle_all_checkbox)

  _bind: ->
    @checkboxes.bind "change", (e) =>
      @_didChangeCheckbox(e.target)
      
    @toggle_all_checkbox.bind "change", (e) =>
      @_didChangeToggleAllCheckbox()

  _didChangeCheckbox: (checkbox) ->
    if @checkboxes.filter(":checked").length == @checkboxes.length - 1
      @_uncheckToggleAllCheckbox()
    else if @checkboxes.filter(":checked").length == @checkboxes.length
      @_checkToggleAllCheckbox()

  _didChangeToggleAllCheckbox: ->
    if @toggle_all_checkbox.attr("checked") == "checked"
      @_checkAllCheckboxes()
    else
      @_uncheckAllCheckboxes()      

  _uncheckToggleAllCheckbox: ->
    @toggle_all_checkbox.removeAttr("checked")

  _checkToggleAllCheckbox: ->
    @toggle_all_checkbox.attr("checked","checked")

  _uncheckAllCheckboxes: ->
    @checkboxes.each (index, el) =>
      $(el).removeAttr("checked")
      @_didChangeCheckbox(el)

  _checkAllCheckboxes: ->
    @checkboxes.each (index, el) =>
      $(el).attr("checked","checked")
      @_didChangeCheckbox(el)
      

( ( $ ) ->
  $.widget.bridge 'aaToggleCheckboxes', CheckboxToggler
)( jQuery )
