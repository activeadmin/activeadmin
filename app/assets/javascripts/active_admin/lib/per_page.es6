ActiveAdmin.PerPage = class PerPage {
  constructor(options, element){
    this.element = element;
    this.$element = $(this.element);
    this._init();
    this._bind();
  }

  _init() {
    this.$params = this._queryParamsToObject();
  }

  _bind() {
    this.$element.change(() => {
      this.$params['per_page'] = this.$element.val();
      delete this.$params['page'];
      if (typeof Turbolinks !== 'undefined') {
        Turbolinks.visit(window.location.href.split('?')[0] + '?' + $.param(this.$params));
      } else {
        window.location.search = $.param(this.$params);
      }
    });
  }

  _queryParamsToObject() {
    let m;
    const query = window.location.search;
    const params = {};
    const re = /\??([^&=]+)=([^&]*)/g;
    while ((m = re.exec(query))) {
      params[this._decode(m[1])] = this._decode(m[2]);
    }
    return params;
  }

  _decode(value) {
    // replace "+" before decodeURIComponent
    return decodeURIComponent(value.replace(/\+/g, '%20'));
  }
};

$.widget.bridge('perPage', ActiveAdmin.PerPage);

const onDOMReady = () => $('.pagination_per_page select').perPage();

$(document).
  ready(onDOMReady).
  on('page:load turbolinks:load', onDOMReady);
