//= require "active_admin/vendor"

/* Active Admin JS */

$(function(){
  $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});

  $(".clear_filters_btn").click(function(){
    window.location.search = "";
    return false;
  });

  $('.panel.toggle h3').live('click', function(e) {
	$(e.target).next('.panel_contents').slideToggle("fast");
    return false;
  });

});
