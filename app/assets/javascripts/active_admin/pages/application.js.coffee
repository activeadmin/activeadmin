#
# Active Admin JS
#


$ ->
  # Date picker
  $(".datepicker").datepicker format: "yyyy-mm-dd"
  $(".clear_filters_btn").click ->
    window.location.search = ""
    false
