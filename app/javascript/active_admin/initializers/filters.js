import Filters from '../lib/filters';

(($) => {

  $(document).
    on('click', '.js-clear-filters-button', Filters._clearForm).
    on('submit', '.filter_form', Filters._disableEmptyInputFields).
    on('change', '.filter_form_field.select_and_search select', Filters._setSearchType);

})(jQuery);
