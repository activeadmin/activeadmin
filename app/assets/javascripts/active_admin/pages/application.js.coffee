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
  $('.filter_form').submit ->
    $(@).find(':input').filter(-> @value is '').prop 'disabled', true

  # Filter form: for filters that let you choose the query method from
  # a dropdown, apply that choice to the filter input field.
  $('.filter_form_field.select_and_search select').change ->
    $(@).siblings('input').prop name: "q[#{@value}]"
