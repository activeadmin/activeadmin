import { queryStringToParams, hasTurbolinks, turbolinksVisit, toQueryString } from '../lib/utils';

class Filters {

  static _clearForm(event) {
    const regex = /^(q\[|q%5B|q%5b|page|utf8|commit)/;
    const params = queryStringToParams()
      .filter(({name}) => !name.match(regex));

    event.preventDefault();

    if (hasTurbolinks()) {
      turbolinksVisit(params);
    } else {
      window.location.search = toQueryString(params);
    }
  }

  static _disableEmptyInputFields(event) {
    const params = $(this)
      .find(':input')
      .filter((i, input) => input.value === '')
      .prop({ disabled: true })
      .end()
      .serializeArray();

    if (hasTurbolinks()) {
      event.preventDefault();
      turbolinksVisit(params);
    }
  }

  static _setSearchType() {
    $(this).siblings('input').prop({name: `q[${this.value}]`});
  }

}

export default Filters;
