(function() {

  $(function() {
    $(".datepicker").datepicker({
      dateFormat: "yy-mm-dd"
    });
    return $(".clear_filters_btn").click(function() {
      window.location.search = "";
      return false;
    });
  });

}).call(this);
