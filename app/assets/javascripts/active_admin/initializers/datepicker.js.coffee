$(document).on 'ready page:load', ->
  $(document).on 'focus', 'input.datepicker:not(.hasDatepicker)', ->
    input = $(@)

    # Only create datepickers in compatible browsers
    return if input[0].type is 'date'

    defaults = dateFormat: 'yy-mm-dd'
    options  = input.data 'datepicker-options'
    input.datepicker $.extend(defaults, options)
