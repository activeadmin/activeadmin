# Datepicker Initializer
$ ->
  # jQuery datepickers (also evaluates dynamically added HTML)
  $(document).on 'focus', '.datepicker:not(.hasDatepicker)', ->
    defaults = dateFormat: 'yy-mm-dd'
    options = $(@).data 'datepicker-options'
    $(@).datepicker $.extend(defaults, options)
