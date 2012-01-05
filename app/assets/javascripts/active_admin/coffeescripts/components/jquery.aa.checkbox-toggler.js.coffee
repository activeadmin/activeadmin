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
    @_bindToggleAllCheckbox()
    @_bindAllCheckboxes()

  _bindToggleAllCheckbox: ->
    @checkboxes.bind "change", (e) =>
      if @checkboxes.filter(":checked").length == @checkboxes.length - 1
        @_uncheckToggleAllCheckbox()
      else if @checkboxes.filter(":checked").length == @checkboxes.length
        @_checkToggleAllCheckbox()

  _bindAllCheckboxes: ->
    @toggle_all_checkbox.bind "change", (e) =>
      if @_toggleAllIsChecked() == false
        @_uncheckAllCheckboxes()
      else
        @_checkAllCheckboxes()

  _uncheckToggleAllCheckbox: ->
    @toggle_all_checkbox.removeAttr("checked")

  _checkToggleAllCheckbox: ->
    @toggle_all_checkbox.attr("checked","checked")

  _toggleAllIsChecked: ->
    @toggle_all_checkbox.attr("checked") == "checked"

  _uncheckAllCheckboxes: ->
    @checkboxes.removeAttr("checked")

  _checkAllCheckboxes: ->
    @checkboxes.attr("checked","checked")    

( ( $ ) ->
  $.widget.bridge 'aaToggleCheckboxes', CheckboxToggler
)( jQuery )
