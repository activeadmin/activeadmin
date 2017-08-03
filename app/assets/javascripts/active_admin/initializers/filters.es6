const onDOMReady = function() {
  // Clear Filters button
  $('.clear_filters_btn').click(function(event) {
    const params = window.location.search.slice(1).split('&');
    const regex = /^(q\[|q%5B|q%5b|page|commit)/;
    const cleanedParams = params.filter(param => !param.match(regex));

    if (typeof Turbolinks !== 'undefined') {
      event.preventDefault();
      Turbolinks.visit(window.location.href.split('?')[0] + '?' + cleanedParams.join('&'));
    } else {
      window.location.search = cleanedParams.join('&');
    }
  });

  // Filter form: don't send any inputs that are empty
  $('.filter_form').submit(function(event) {
    $(this)
      .find(':input')
      .filter(function() {
        return this.value === '';
      })
      .prop('disabled', true);

    if (typeof Turbolinks !== 'undefined') {
      event.preventDefault();
      Turbolinks.visit(window.location.href.split('?')[0] + '?' + $(this).serialize());
    }
  });

  // Filter form: for filters that let you choose the query method from
  // a dropdown, apply that choice to the filter input field.
  $('.filter_form_field.select_and_search select').change(function() {
    $(this).siblings('input').prop({name: `q[${this.value}]`});
  });
};

$(document).
  ready(onDOMReady).
  on('page:load turbolinks:load', onDOMReady);
