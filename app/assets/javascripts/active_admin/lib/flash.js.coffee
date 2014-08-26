ActiveAdmin.flash =
  error: (message) ->
    this.abstract message, 'error'
  notice: (message) ->
    this.abstract message, 'notice'
  abstract: (message, type) ->
    $('.flashes').append "<div class='flash flash_#{type}'>#{message}</div>"
