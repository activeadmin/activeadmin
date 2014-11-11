# Initializers
@setupDateTimePicker = (container) ->
  defaults = {
    formatDate: 'y-m-d',
    format: 'Y-m-d H:i',
    allowBlank: true,
    defaultSelect: false,
    validateOnBlur: false
  }

  entries = $(container).find('.combined-date-time-picker')
  entries.each (index, entry) ->
    options = $(entry).data 'datepicker-options'
    $(entry).datetimepicker $.extend(defaults, options)


$ ->
  # jQuery datepickers (also evaluates dynamically added HTML)
  $(document).on 'focus', '.datepicker:not(.hasDatepicker)', ->
    defaults = dateFormat: 'yy-mm-dd'
    options = $(@).data 'datepicker-options'
    $(@).datepicker $.extend(defaults, options)

  setupDateTimePicker $('body')
  $(document).on 'has_many_add:after', '.has_many_container', (e, fieldset) ->
    setupDateTimePicker fieldset

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

  # Tab navigation in the show page
  $('#main_content .tabs').tabs()

  # In order for index scopes to overflow properly onto the next line, we have
  # to manually set its width based on the width of the batch action button.
  if (batch_actions_selector = $('.table_tools .batch_actions_selector')).length
    batch_actions_selector.next().css
      width: "calc(100% - 10px - #{batch_actions_selector.outerWidth()}px)"
      'float': 'right'
