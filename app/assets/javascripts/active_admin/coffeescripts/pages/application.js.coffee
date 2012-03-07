#
# Active Admin JS
#

# Date picker

$ ->
  $(".datepicker").datepicker dateFormat: "yy-mm-dd"
  $(".clear_filters_btn").click ->
    window.location.search = ""
    false

