jQuery ($) ->

  #
  # Use Rails.js click handler to allow for Rails' confirm dialogs
  #

  $(document).delegate "#batch_actions_selector li a", "click.rails", ->
    $("#batch_action").val $(this).attr("data-action")
    $("#collection_selection").submit()

  #
  # Add checkbox selection to resource tables and lists if batch actions are enabled
  #

  if $("#batch_actions_selector").length && $(":checkbox.toggle_all").length

    if $(".paginated_collection").find("table").length
      $(".paginated_collection table").tableCheckboxToggler()
    else
      $(".paginated_collection").checkboxToggler()

    $(".paginated_collection").find(":checkbox").bind "change", ->
      if $(".paginated_collection").find(":checkbox").filter(":checked").length > 0
        $("#batch_actions_selector").aaDropdownMenu("enable")
      else
        $("#batch_actions_selector").aaDropdownMenu("disable")
