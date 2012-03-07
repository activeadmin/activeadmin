jQuery ($) ->

  # 
  # Init batch action popover
  #

  $("#batch_actions_button").popover autoOpen: false

  #
  # Use Rails.js click handler to allow for Rails' confirm dialogs
  #

  $(document).delegate "#batch_actions_popover li a", "click.rails", ->
    $("#batch_action").val $(this).attr("data-action")
    $("#collection_selection").submit()

  #
  # Toggle showing / hiding the batch actions popover
  #

  $("#batch_actions_button").click ->
    unless $(this).hasClass("disabled")
      if $("#batch_actions_popover").is(":hidden")
        $(this).popover "open"
        return false
      else
        $(this).popover "close"
        return false

  #
  # Add checkbox selection to resource tables and lists if batch actions are enabled
  #

  if $("#batch_actions_button").length && $(":checkbox.toggle_all").length
  
    if $(".paginated_collection").find("table").length
      $(".paginated_collection table").tableCheckboxToggler()
    else
      $(".paginated_collection").checkboxToggler()

    $(".paginated_collection").find(":checkbox").bind "change", ->
      if $(".paginated_collection").find(":checkbox").filter(":checked").length > 0
        $("#batch_actions_button").removeClass("disabled")
      else
        $("#batch_actions_button").addClass("disabled")
