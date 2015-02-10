# Short-circuits `_focusTabbable` to focus on the modal itself instead of
# elements inside the modal. Without this, if a datepicker is the first input,
# it'll immediately pop up when the modal opens.
# See this ticket for more info: http://bugs.jqueryui.com/ticket/4731
$.ui.dialog.prototype._focusTabbable = ->
  @uiDialog.focus()
