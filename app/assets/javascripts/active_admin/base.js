//= require "active_admin/vendor"

/* Active Admin JS */

$(function(){
  $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});

  $(".clear_filters_btn").click(function(){
    window.location.search = "";
    return false;
  });

  $('#batch_actions_button:not(:disabled)').toggle(function() {
    $("#batch_actions_popover").fadeIn(50);
  }, function() {
    $("#batch_actions_popover").fadeOut(100);
  });

});
