import Filters from '../lib/filters';

(($) => {

  $(document).
    on('click', '.clear_filters_btn', Filters._clearForm).
    on('submit', '.filter_form', Filters._disableEmptyInputFields).
    on('change', '.filter_form_field.select_and_search select', Filters._setSearchType);

})(jQuery);
