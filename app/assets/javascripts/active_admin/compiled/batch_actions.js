(function() {

  jQuery(function($) {
    $("#batch_actions_button").popover({
      autoOpen: false
    });
    $(document).delegate("#batch_actions_popover li a", "click.rails", function() {
      $("#batch_action").val($(this).attr("data-action"));
      return $("#collection_selection").submit();
    });
    $("#batch_actions_button").click(function() {
      if (!$(this).hasClass("disabled")) {
        if ($("#batch_actions_popover").is(":hidden")) {
          $(this).popover("open");
          return false;
        } else {
          $(this).popover("close");
          return false;
        }
      }
    });
    if ($(".paginated_collection").find("table").length) {
      $(".paginated_collection table").tableCheckboxToggler();
    } else {
      $(".paginated_collection").checkboxToggler();
    }
    return $(".paginated_collection").find(":checkbox").bind("change", function() {
      if ($(".paginated_collection").find(":checkbox").filter(":checked").length > 0) {
        return $("#batch_actions_button").removeClass("disabled");
      } else {
        return $("#batch_actions_button").addClass("disabled");
      }
    });
  });

}).call(this);
