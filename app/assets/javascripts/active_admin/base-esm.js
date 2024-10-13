import $ from "jquery";

import "jquery-ui/ui/widget";

import "jquery-ui/ui/position";

import "jquery-ui/ui/data";

import "jquery-ui/ui/disable-selection";

import "jquery-ui/ui/focusable";

import "jquery-ui/ui/form-reset-mixin";

import "jquery-ui/ui/keycode";

import "jquery-ui/ui/labels";

import "jquery-ui/ui/scroll-parent";

import "jquery-ui/ui/tabbable";

import "jquery-ui/ui/unique-id";

import "jquery-ui/ui/widgets/draggable";

import "jquery-ui/ui/widgets/resizable";

import "jquery-ui/ui/widgets/sortable";

import "jquery-ui/ui/widgets/button";

import "jquery-ui/ui/widgets/checkboxradio";

import "jquery-ui/ui/widgets/controlgroup";

import "jquery-ui/ui/widgets/datepicker";

import "jquery-ui/ui/widgets/dialog";

import "jquery-ui/ui/widgets/mouse";

import "jquery-ui/ui/widgets/tabs";

import Rails from "@rails/ujs";

window.jQuery = $;

window.$ = $;

$.fn.serializeObject = function() {
  return this.serializeArray().reduce(((obj, item) => {
    obj[item.name] = item.value;
    return obj;
  }), {});
};

$.ui.dialog.prototype._focusTabbable = function() {
  this.uiDialog.focus();
};

function ModalDialog(message, inputs, callback) {
  let html = `<form id="dialog_confirm" title="${message}"><ul>`;
  for (let name in inputs) {
    var opts, wrapper;
    let type = inputs[name];
    if (/^(datepicker|checkbox|text|number)$/.test(type)) {
      wrapper = "input";
    } else if (type === "textarea") {
      wrapper = "textarea";
    } else if ($.isArray(type)) {
      [wrapper, opts, type] = [ "select", type, "" ];
    } else {
      throw new Error(`Unsupported input type: {${name}: ${type}}`);
    }
    let klass = type === "datepicker" ? type : "";
    html += `<li>\n      <label>${name.charAt(0).toUpperCase() + name.slice(1)}</label>\n      <${wrapper} name="${name}" class="${klass}" type="${type}">` + (opts ? (() => {
      const result = [];
      opts.forEach((v => {
        const $elem = $("<option></option>");
        if ($.isArray(v)) {
          $elem.text(v[0]).val(v[1]);
        } else {
          $elem.text(v);
        }
        result.push($elem.wrap("<div></div>").parent().html());
      }));
      return result;
    })().join("") : "") + `</${wrapper}>` + "</li>";
    [wrapper, opts, type, klass] = [];
  }
  html += "</ul></form>";
  const form = $(html).appendTo("body");
  $("body").trigger("modal_dialog:before_open", [ form ]);
  form.dialog({
    modal: true,
    open(_event, _ui) {
      $("body").trigger("modal_dialog:after_open", [ form ]);
    },
    dialogClass: "active_admin_dialog",
    buttons: {
      OK() {
        callback($(this).serializeObject());
        $(this).dialog("close");
      },
      Cancel() {
        $(this).dialog("close").remove();
      }
    }
  });
}

const onDOMReady$2 = function() {
  $(".batch_actions_selector li a").off("click confirm:complete");
  $(".batch_actions_selector li a").on("click", (function(event) {
    let message;
    event.stopPropagation();
    event.preventDefault();
    if (message = $(this).data("confirm")) {
      ModalDialog(message, $(this).data("inputs"), (inputs => {
        $(this).trigger("confirm:complete", inputs);
      }));
    } else {
      $(this).trigger("confirm:complete");
    }
  }));
  $(".batch_actions_selector li a").on("confirm:complete", (function(event, inputs) {
    let val;
    if (val = JSON.stringify(inputs)) {
      $("#batch_action_inputs").removeAttr("disabled").val(val);
    } else {
      $("#batch_action_inputs").attr("disabled", "disabled");
    }
    $("#batch_action").val($(this).data("action"));
    $("#collection_selection").submit();
  }));
  if ($(".batch_actions_selector").length && $(":checkbox.toggle_all").length) {
    if ($(".paginated_collection table.index_table").length) {
      $(".paginated_collection table.index_table").tableCheckboxToggler();
    } else {
      $(".paginated_collection").checkboxToggler();
    }
    $(document).on("change", ".paginated_collection :checkbox", (function() {
      if ($(".paginated_collection :checkbox:checked").length && $(".dropdown_menu_list").children().length) {
        $(".batch_actions_selector").each((function() {
          $(this).aaDropdownMenu("enable");
        }));
      } else {
        $(".batch_actions_selector").each((function() {
          $(this).aaDropdownMenu("disable");
        }));
      }
    }));
  }
};

$(document).ready(onDOMReady$2).on("page:load turbolinks:load", onDOMReady$2);

class CheckboxToggler {
  constructor(options, container) {
    this.options = options;
    this.container = container;
    this._init();
    this._bind();
  }
  option(_key, _value) {}
  _init() {
    if (!this.container) {
      throw new Error("Container element not found");
    } else {
      this.$container = $(this.container);
    }
    if (!this.$container.find(".toggle_all").length) {
      throw new Error('"toggle all" checkbox not found');
    } else {
      this.toggle_all_checkbox = this.$container.find(".toggle_all");
    }
    this.checkboxes = this.$container.find(":checkbox").not(this.toggle_all_checkbox);
  }
  _bind() {
    this.checkboxes.change((event => this._didChangeCheckbox(event.target)));
    this.toggle_all_checkbox.change((() => this._didChangeToggleAllCheckbox()));
  }
  _didChangeCheckbox(_checkbox) {
    const numChecked = this.checkboxes.filter(":checked").length;
    const allChecked = numChecked === this.checkboxes.length;
    const someChecked = numChecked > 0 && numChecked < this.checkboxes.length;
    this.toggle_all_checkbox.prop({
      checked: allChecked,
      indeterminate: someChecked
    });
  }
  _didChangeToggleAllCheckbox() {
    const setting = this.toggle_all_checkbox.prop("checked");
    this.checkboxes.prop({
      checked: setting
    });
    return setting;
  }
}

$.widget.bridge("checkboxToggler", CheckboxToggler);

($ => {
  $(document).on("focus", "input.datepicker:not(.hasDatepicker)", (function() {
    const input = $(this);
    if (input[0].type === "date") {
      return;
    }
    const defaults = {
      dateFormat: "yy-mm-dd"
    };
    const options = input.data("datepicker-options");
    input.datepicker($.extend(defaults, options));
  }));
})($);

class DropdownMenu {
  constructor(options, element) {
    this.options = options;
    this.element = element;
    this.$element = $(this.element);
    const defaults = {
      fadeInDuration: 20,
      fadeOutDuration: 100,
      onClickActionItemCallback: null
    };
    this.options = $.extend(defaults, this.options);
    this.isOpen = false;
    this.$menuButton = this.$element.find(".dropdown_menu_button");
    this.$menuList = this.$element.find(".dropdown_menu_list_wrapper");
    this._buildMenuList();
    this._bind();
  }
  open() {
    this.isOpen = true;
    this.$menuList.fadeIn(this.options.fadeInDuration);
    this._position();
    return this;
  }
  close() {
    this.isOpen = false;
    this.$menuList.fadeOut(this.options.fadeOutDuration);
    return this;
  }
  destroy() {
    this.$element = null;
    return this;
  }
  isDisabled() {
    return this.$menuButton.hasClass("disabled");
  }
  disable() {
    this.$menuButton.addClass("disabled");
  }
  enable() {
    this.$menuButton.removeClass("disabled");
  }
  option(key, value) {
    if ($.isPlainObject(key)) {
      return this.options = $.extend(true, this.options, key);
    } else if (key != null) {
      return this.options[key];
    } else {
      return this.options[key] = value;
    }
  }
  _buildMenuList() {
    this.$nipple = $('<div class="dropdown_menu_nipple"></div>');
    this.$menuList.prepend(this.$nipple);
    this.$menuList.hide();
  }
  _bind() {
    $("body").click((() => {
      if (this.isOpen) {
        this.close();
      }
    }));
    this.$menuButton.click((() => {
      if (!this.isDisabled()) {
        if (this.isOpen) {
          this.close();
        } else {
          this.open();
        }
      }
      return false;
    }));
  }
  _position() {
    this.$menuList.css("top", this.$menuButton.position().top + this.$menuButton.outerHeight() + 10);
    const button_left = this.$menuButton.position().left;
    const button_center = this.$menuButton.outerWidth() / 2;
    const button_right = button_left + button_center * 2;
    const menu_center = this.$menuList.outerWidth() / 2;
    const nipple_center = this.$nipple.outerWidth() / 2;
    const window_right = $(window).width();
    const centered_menu_left = button_left + button_center - menu_center;
    const centered_menu_right = button_left + button_center + menu_center;
    if (centered_menu_left < 0) {
      this.$menuList.css("left", button_left);
      this.$nipple.css("left", button_center - nipple_center);
    } else if (centered_menu_right > window_right) {
      this.$menuList.css("right", window_right - button_right);
      this.$nipple.css("right", button_center - nipple_center);
    } else {
      this.$menuList.css("left", centered_menu_left);
      this.$nipple.css("left", menu_center - nipple_center);
    }
  }
}

$.widget.bridge("aaDropdownMenu", DropdownMenu);

const onDOMReady$1 = () => $(".dropdown_menu").aaDropdownMenu();

$(document).ready(onDOMReady$1).on("page:load turbolinks:load", onDOMReady$1);

function hasTurbolinks() {
  return typeof Turbolinks !== "undefined" && Turbolinks.supported;
}

function turbolinksVisit(params) {
  const path = [ window.location.pathname, "?", toQueryString(params) ].join("");
  Turbolinks.visit(path);
}

function queryString() {
  return (window.location.search || "").replace(/^\?/, "");
}

function queryStringToParams() {
  const decode = value => decodeURIComponent((value || "").replace(/\+/g, "%20"));
  return queryString().split("&").map((pair => pair.split("="))).map((([key, value]) => ({
    name: decode(key),
    value: decode(value)
  })));
}

function toQueryString(params) {
  const encode = value => encodeURIComponent(value || "");
  return params.map((({name: name, value: value}) => [ encode(name), encode(value) ])).map((pair => pair.join("="))).join("&");
}

class Filters {
  static _clearForm(event) {
    const regex = /^(q\[|q%5B|q%5b|page|utf8|commit)/;
    const params = queryStringToParams().filter((({name: name}) => !name.match(regex)));
    event.preventDefault();
    if (hasTurbolinks()) {
      turbolinksVisit(params);
    } else {
      window.location.search = toQueryString(params);
    }
  }
  static _disableEmptyInputFields(event) {
    const params = $(this).find(":input").filter(((i, input) => input.value === "")).prop({
      disabled: true
    }).end().serializeArray();
    if (hasTurbolinks()) {
      event.preventDefault();
      turbolinksVisit(params);
    }
  }
  static _setSearchType() {
    $(this).siblings("input").prop({
      name: `q[${this.value}]`
    });
  }
}

($ => {
  $(document).on("click", ".clear_filters_btn", Filters._clearForm).on("submit", ".filter_form", Filters._disableEmptyInputFields).on("change", ".filter_form_field.select_and_search select", Filters._setSearchType);
})($);

$((function() {
  $(document).on("click", "a.button.has_many_remove", (function(event) {
    event.preventDefault();
    const parent = $(this).closest(".has_many_container");
    const to_remove = $(this).closest("fieldset");
    recompute_positions(parent);
    parent.trigger("has_many_remove:before", [ to_remove, parent ]);
    to_remove.remove();
    return parent.trigger("has_many_remove:after", [ to_remove, parent ]);
  }));
  $(document).on("click", "a.button.has_many_add", (function(event) {
    let before_add;
    event.preventDefault();
    const parent = $(this).closest(".has_many_container");
    parent.trigger(before_add = $.Event("has_many_add:before"), [ parent ]);
    if (!before_add.isDefaultPrevented()) {
      let index = parent.data("has_many_index") || parent.children("fieldset").length - 1;
      parent.data({
        has_many_index: ++index
      });
      const regex = new RegExp($(this).data("placeholder"), "g");
      const html = $(this).data("html").replace(regex, index);
      const fieldset = $(html).insertBefore(this);
      recompute_positions(parent);
      return parent.trigger("has_many_add:after", [ fieldset, parent ]);
    }
  }));
  $(document).on("change", '.has_many_container[data-sortable] :input[name$="[_destroy]"]', (function() {
    recompute_positions($(this).closest(".has_many"));
  }));
  $(document).on("has_many_add:after", ".has_many_container", init_sortable);
}));

var init_sortable = function() {
  const elems = $(".has_many_container[data-sortable]:not(.ui-sortable)");
  elems.sortable({
    items: "> fieldset",
    handle: "> ol > .handle",
    start: (ev, ui) => {
      ui.item.css({
        opacity: .3
      });
    },
    stop: function(ev, ui) {
      ui.item.css({
        opacity: 1
      });
      recompute_positions($(this));
    }
  });
  elems.each(recompute_positions);
};

var recompute_positions = function(parent) {
  parent = parent instanceof $ ? parent : $(this);
  const input_name = parent.data("sortable");
  let position = parseInt(parent.data("sortable-start") || 0, 10);
  parent.children("fieldset").each((function() {
    const destroy_input = $(this).find("> ol > .input > :input[name$='[_destroy]']");
    const sortable_input = $(this).find(`> ol > .input > :input[name$='[${input_name}]']`);
    if (sortable_input.length) {
      sortable_input.val(destroy_input.is(":checked") ? "" : position++);
    }
  }));
};

$(document).ready(init_sortable).on("page:load turbolinks:load", init_sortable);

class PerPage {
  constructor(element) {
    this.element = element;
  }
  update() {
    const params = queryStringToParams().filter((({name: name}) => name != "per_page" || name != "page"));
    params.push({
      name: "per_page",
      value: this.element.value
    });
    if (hasTurbolinks()) {
      turbolinksVisit(params);
    } else {
      window.location.search = toQueryString(params);
    }
  }
  static _jQueryInterface(config) {
    return this.each((function() {
      const $this = $(this);
      let data = $this.data("perPage");
      if (!data) {
        data = new PerPage(this);
        $this.data("perPage", data);
      }
      if (config === "update") {
        data[config]();
      }
    }));
  }
}

($ => {
  $(document).on("change", ".pagination_per_page > select", (function(_event) {
    PerPage._jQueryInterface.call($(this), "update");
  }));
  $.fn["perPage"] = PerPage._jQueryInterface;
  $.fn["perPage"].Constructor = PerPage;
})($);

class TableCheckboxToggler extends CheckboxToggler {
  _bind() {
    super._bind(...arguments);
    this.$container.find("tbody td").click((event => {
      if (event.target.type !== "checkbox") {
        this._didClickCell(event.target);
      }
    }));
  }
  _didChangeCheckbox(checkbox) {
    super._didChangeCheckbox(...arguments);
    $(checkbox).parents("tr").toggleClass("selected", checkbox.checked);
  }
  _didChangeToggleAllCheckbox() {
    this.$container.find("tbody tr").toggleClass("selected", super._didChangeToggleAllCheckbox(...arguments));
  }
  _didClickCell(cell) {
    $(cell).parent("tr").find(":checkbox").click();
  }
}

$.widget.bridge("tableCheckboxToggler", TableCheckboxToggler);

let onDOMReady = () => $("#active_admin_content .tabs").tabs();

$(document).ready(onDOMReady).on("page:load turbolinks:load", onDOMReady);

Rails.start();

function modal_dialog(message, inputs, callback) {
  console.warn("ActiveAdmin.modal_dialog is deprecated in favor of ActiveAdmin.ModalDialog, please update usage.");
  return ModalDialog(message, inputs, callback);
}

export { ModalDialog, modal_dialog };
