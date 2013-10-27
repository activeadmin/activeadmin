jQuery ($) ->

  $('.download_links a').click (e) ->
    e.preventDefault()

    $btn = $(this)
    $export_dialog = $("#export_dialog")
    $export_dialog.dialog
      autoOpen: true
      modal:    true
      buttons:
        "Cancel": ->
          $(this).dialog("close");
        "Export": ->
          $export_form = $export_dialog.find("form")
          target = $btn.attr("href")

          if target.indexOf("?") == -1
            append = "?"
          else
            append = "&"

          append += $export_form.serialize()

          window.location = target + append

    return false