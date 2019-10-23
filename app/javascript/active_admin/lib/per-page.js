import { queryStringToParams, hasTurbolinks, turbolinksVisit, toQueryString } from './utils';

class PerPage {
  constructor(element) {
    this.element = element;
  }

  update() {
    const params = queryStringToParams()
      .filter(({name}) => name != 'per_page' || name != 'page')

    params.push({ name: 'per_page', value: this.element.value });

    if (hasTurbolinks()) {
      turbolinksVisit(params);
    } else {
      window.location.search = toQueryString(params);
    }
  }

  static _jQueryInterface(config) {
    return this.each(function () {
      const $this = $(this)
      let data = $this.data('perPage')

      if (!data) {
        data = new PerPage(this)
        $this.data('perPage', data)
      }

      if (config === 'update') {
        data[config]()
      }
    })
  }
};

export default PerPage;
