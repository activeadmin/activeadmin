import PerPage from "../lib/per-page";

(($) => {

  $(document).
    on('change', '.pagination_per_page > select', function(_event) {
      PerPage._jQueryInterface.call($(this), 'update')
    });

  $.fn['perPage'] = PerPage._jQueryInterface
  $.fn['perPage'].Constructor = PerPage

})(jQuery);
