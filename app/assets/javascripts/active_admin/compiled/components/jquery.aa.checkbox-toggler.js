(function() {
  var CheckboxToggler;

  window.CheckboxToggler = CheckboxToggler = (function() {

    function CheckboxToggler(container, options) {
      this.container = container;
      this.options = options;
      this._init();
      this._bind();
    }

    CheckboxToggler.prototype._init = function() {
      if (!this.container) throw new Error("Container element not found");
      if (!this.container.find(".toggle_all").length) {
        throw new Error("'toggle all' checkbox not found");
      } else {
        this.toggle_all_checkbox = this.container.find(".toggle_all");
      }
      return this.checkboxes = this.container.find(":checkbox").not(this.toggle_all_checkbox);
    };

    CheckboxToggler.prototype._bind = function() {
      this._bindToggleAllCheckbox();
      return this._bindAllCheckboxes();
    };

    CheckboxToggler.prototype._bindToggleAllCheckbox = function() {
      var _this = this;
      return this.checkboxes.bind("change", function(e) {
        if (_this.checkboxes.filter(":checked").length === _this.checkboxes.length - 1) {
          return _this._uncheckToggleAllCheckbox();
        } else if (_this.checkboxes.filter(":checked").length === _this.checkboxes.length) {
          return _this._checkToggleAllCheckbox();
        }
      });
    };

    CheckboxToggler.prototype._bindAllCheckboxes = function() {
      var _this = this;
      return this.toggle_all_checkbox.bind("change", function(e) {
        if (_this._toggleAllIsChecked() === false) {
          return _this._uncheckAllCheckboxes();
        } else {
          return _this._checkAllCheckboxes();
        }
      });
    };

    CheckboxToggler.prototype._uncheckToggleAllCheckbox = function() {
      return this.toggle_all_checkbox.removeAttr("checked");
    };

    CheckboxToggler.prototype._checkToggleAllCheckbox = function() {
      return this.toggle_all_checkbox.attr("checked", "checked");
    };

    CheckboxToggler.prototype._toggleAllIsChecked = function() {
      return this.toggle_all_checkbox.attr("checked") === "checked";
    };

    CheckboxToggler.prototype._uncheckAllCheckboxes = function() {
      return this.checkboxes.removeAttr("checked");
    };

    CheckboxToggler.prototype._checkAllCheckboxes = function() {
      return this.checkboxes.attr("checked", "checked");
    };

    return CheckboxToggler;

  })();

  (function($) {
    return $.widget.bridge('aaToggleCheckboxes', CheckboxToggler);
  })(jQuery);

}).call(this);
