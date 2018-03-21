(($, ActiveAdmin) => {

  class Filters {

    static _clearForm(event) {
      const regex = /^(q\[|q%5B|q%5b|page|utf8|commit)/;
      const params = ActiveAdmin
        .queryStringToParams()
        .filter(({name}) => !name.match(regex));

      event.preventDefault();

      if (ActiveAdmin.turbolinks) {
        ActiveAdmin.turbolinksVisit(params);
      } else {
        window.location.search = ActiveAdmin.toQueryString(params);
      }
    }

    static _disableEmptyInputFields(event) {
      const params = $(this)
        .find(':input')
        .filter((i, input) => input.value === '')
        .prop({ disabled: true })
        .end()
        .serializeArray();

      if (ActiveAdmin.turbolinks) {
        event.preventDefault();
        ActiveAdmin.turbolinksVisit(params);
      }
    }

    static _setSearchType() {
      $(this).siblings('input').prop({name: `q[${this.value}]`});
    }

  }

  $(document).
    on('click', '.clear_filters_btn', Filters._clearForm).
    on('submit', '.filter_form', Filters._disableEmptyInputFields).
    on('change', '.filter_form_field.select_and_search select', Filters._setSearchType);

})(jQuery, window.activeadmin);
