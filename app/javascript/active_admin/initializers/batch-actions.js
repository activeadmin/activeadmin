import ModalDialog from "../lib/modal-dialog";

const onDOMReady = function() {
  // Detach any previously attached handlers before re-attaching them.
  // This avoids double-registered handlers when Turbolinks is enabled
  $('.batch_actions_selector li a').off('click confirm:complete');

  //
  // Use ModalDialog to prompt user if
  // confirmation is required for current Batch Action
  //
  $('.batch_actions_selector li a').on('click', function(event){
    let message;
    event.stopPropagation(); // prevent Rails UJS click event
    event.preventDefault();
    if ((message = $(this).data('confirm'))) {
      ModalDialog(message, $(this).data('inputs'), inputs => {
        $(this).trigger('confirm:complete', inputs);
      });
    } else {
      $(this).trigger('confirm:complete');
    }
  });

  $('.batch_actions_selector li a').on('confirm:complete', function(event, inputs){
    let val;
    if ((val = JSON.stringify(inputs))) {
      $('#batch_action_inputs').removeAttr('disabled').val(val);
    } else {
      $('#batch_action_inputs').attr('disabled', 'disabled');
    }

    $('#batch_action').val($(this).data('action'));
    $('#collection_selection').submit();
  });

  //
  // Add checkbox selection to resource tables and lists if batch actions are enabled
  //

  if ($(".batch_actions_selector").length && $(":checkbox.toggle_all").length) {

    if ($(".paginated_collection table.index_table").length) {
      $(".paginated_collection table.index_table").tableCheckboxToggler();
    } else {
      $(".paginated_collection").checkboxToggler();
    }

    $(document).on('change', '.paginated_collection :checkbox', function() {
      if ($(".paginated_collection :checkbox:checked").length && $(".dropdown-menu").children().length) {
        $(".batch_actions_selector").each(function() { $(this).aaDropdownMenu("enable"); });
      } else {
        $(".batch_actions_selector").each(function() { $(this).aaDropdownMenu("disable"); });
      }
    });
  }
};

$(document).
  ready(onDOMReady).
  on('page:load turbolinks:load', onDOMReady);
