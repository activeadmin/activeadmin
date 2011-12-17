jQuery(function($) {

  //
  // Init batch action popover
  //

  $("#batch_actions_button").aaPopover({autoOpen: false});
  
  //
  // Use Rails.js click handler to allow for confirm dialogs
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

  //
  // Toggle selecting / deselecting an entire page of records
  // @TODO Refactor into object
  //

  $('#collection_selection_toggle_all').click(function() {
	
		var $this = $(this);
		var isTable = $this.closest(".index").hasClass("index_table");
	
    if ($(this).attr('checked') == "checked") {
      $('#batch_actions_button').removeClass("disabled");
      $('#batch_actions_button').addClass("selected");
			$('.collection_selection').attr('checked', 'checked');
      if ( isTable ) {
				$(this).parents(".index_table").find('tr').addClass("selected");
			}
    } else {
      $('#batch_actions_button').addClass("disabled");
      $('#batch_actions_button').removeClass("selected");
			$('.collection_selection').attr('checked', false);
      if ( isTable ) {
				$(this).parents(".index_table").find('tr').removeClass("selected");
			}
    }
  });

  //
  // Toggle selection of a individual record
  // @TODO Refactor into object
  //
  
  $('.collection_selection').click(function() {
	
		var $this = $(this);
		var isTable = $this.closest(".index").hasClass("index_table");
		
    if ( $this.attr('checked') == "checked" ) {
	
      $('#batch_actions_button').removeClass("disabled");
      $('#batch_actions_button').addClass("selected");
      if ( isTable ) {
				$this.parents('tr').addClass("selected");
			}

    } else {
      
			if ( $this.closest(".index").find("input:checked").length == 0) {
        $('#batch_actions_button').addClass("disabled");
        $('#batch_actions_button').removeClass("selected");
      }
      
			if ( isTable ) {
	      $this.parents('tr').removeClass("selected");
			}
      
			$("#collection_selection_toggle_all").attr('checked', false);
      
    }

  });
	
});
