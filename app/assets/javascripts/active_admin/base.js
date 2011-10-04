//= require "active_admin/vendor"

/* Active Admin JS */

$(function(){
  $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});

  $(".clear_filters_btn").click(function(){
    window.location.search = "";
    return false;
  });

  $('#batch_actions_button').toggle(function() {
    $("#batch_actions_popover").fadeIn(50);
  }, function() {
    $("#batch_actions_popover").fadeOut(100);
  });
  
  $('.index_table thead :checkbox').toggle(function() {
    $('#batch_actions_button').removeClass("disabled");
    $('#batch_actions_button').addClass("selected");
    $(this).parents(".index_table").find('tr :checkbox').attr('checked', 'true');
    $(this).attr('checked', 'true');
  }, function() {
    $('#batch_actions_button').addClass("disabled");
    $('#batch_actions_button').removeClass("selected");
    $(this).parents(".index_table").find('tr :checkbox').attr('checked', '');
    $(this).attr('checked', 'false');
  });
  
  $('.index_table tbody :checkbox').toggle(function() {
    $('#batch_actions_button').removeClass("disabled");
    $('#batch_actions_button').addClass("selected");
    return true;
  }, function() {
    $('#batch_actions_button').addClass("disabled");
    $('#batch_actions_button').removeClass("selected");
    return true;
    
  });

});
