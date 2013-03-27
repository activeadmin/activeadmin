# Initializers
$ ->
  # jQuery datepickers (also evaluates dynamically added HTML)
  $(document).on 'focus', '.datepicker:not(.hasDatepicker)', ->
    $(@).datepicker dateFormat: 'yy-mm-dd'

  # Clear Filters button
  $('.clear_filters_btn').click ->
    window.location.search = ''

  # Batch Actions dropdown
  $('.dropdown_button').popover()

  # Filter form: don't send any inputs that are empty
  $('#q_search').submit ->
    $(@).find(':input').filter(-> @value is '').prop 'disabled', true
