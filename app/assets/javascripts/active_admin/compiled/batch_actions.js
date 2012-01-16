jQuery(function($) {

  //
  // Init batch action popover
  //

  $("#batch_actions_button").aaPopover({autoOpen: false});
  
  //
  // Use Rails.js click handler to allow for Rails' confirm dialogs
  //

  $(document).delegate("#batch_actions_popover li a", 'click.rails', function() {
    $('#batch_action').val( $(this).attr("data-action"));
    $('#collection_selection').submit();
  });

  //
  // Toggle showing / hiding the batch actions popover
  //

  $('#batch_actions_button').click(function() {
    if (!$(this).hasClass("disabled")) {
      if ($("#batch_actions_popover").is(":hidden")) {
        $(this).aaPopover("open");
        return false;
      } else {
        $(this).aaPopover("close");
        return false;
      }
    };
  });

  new TableCheckboxToggler($(".paginated_collection table"));
	
});

