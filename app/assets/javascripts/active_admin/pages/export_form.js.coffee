jQuery ($) ->

  $('[data-export-modal]').click (e) ->
    e.preventDefault()

    $btn = $(this)

    inputs =
      "export[start]": "text"
      "export[end]":   "text"

    ActiveAdmin.modalDialog "Export Data", inputs, (inputs)=>
      target = $btn.attr("href")

      if target.indexOf("?") == -1
        append = "?"
      else
        append = "&"

      append += $.param(inputs)

      window.location = target + append

    return false