onDOMReady = ->
  # Clear Filters button
  $('.clear_filters_btn').click (e) ->
    params = window.location.search.slice(1).split('&')
    regex = /^(q\[|q%5B|q%5b|page|commit)/
    if typeof Turbolinks != 'undefined'
      Turbolinks.visit(window.location.href.split('?')[0] + '?' + (param for param in params when not param.match(regex)).join('&'))
      e.preventDefault()
    else
      window.location.search = (param for param in params when not param.match(regex)).join('&')

  # Filter form: don't send any inputs that are empty
  $('.filter_form').submit (e) ->
    $(@).find(':input').filter(-> @value is '').prop 'disabled', true
    if typeof Turbolinks != 'undefined'
      Turbolinks.visit(window.location.href.split('?')[0] + '?' + $( this ).serialize())
      e.preventDefault()

  # Filter form: for filters that let you choose the query method from
  # a dropdown, apply that choice to the filter input field.
  $('.filter_form_field.select_and_search select').change ->
    $(@).siblings('input').prop name: "q[#{@value}]"

$(document).
  ready(onDOMReady).
  on 'page:load turbolinks:load', onDOMReady
