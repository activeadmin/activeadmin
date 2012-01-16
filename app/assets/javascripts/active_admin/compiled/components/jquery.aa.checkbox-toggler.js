(function() {

  window.AA.CheckboxToggler = AA.CheckboxToggler = (function() {

    function CheckboxToggler(options, container) {
      var defaults;
      this.options = options;
      this.container = container;
      defaults = {};
      this.options = $.extend({}, defaults, options);
      this._init();
      this._bind();
    }

    CheckboxToggler.prototype._init = function() {
      if (!this.container) {
        throw new Error("Container element not found");
      } else {
        this.$container = $(this.container);
      }
      if (!this.$container.find(".toggle_all").length) {
        throw new Error("'toggle all' checkbox not found");
      } else {
        this.toggle_all_checkbox = this.$container.find(".toggle_all");
      }
      return this.checkboxes = this.$container.find(":checkbox").not(this.toggle_all_checkbox);
    };

    CheckboxToggler.prototype._bind = function() {
      var _this = this;
      this.checkboxes.bind("change", function(e) {
        return _this._didChangeCheckbox(e.target);
      });
      return this.toggle_all_checkbox.bind("change", function(e) {
        return _this._didChangeToggleAllCheckbox();
      });
    };

    CheckboxToggler.prototype._didChangeCheckbox = function(checkbox) {
      if (this.checkboxes.filter(":checked").length === this.checkboxes.length - 1) {
        return this._uncheckToggleAllCheckbox();
      } else if (this.checkboxes.filter(":checked").length === this.checkboxes.length) {
        return this._checkToggleAllCheckbox();
      }
    };

    CheckboxToggler.prototype._didChangeToggleAllCheckbox = function() {
      if (this.toggle_all_checkbox.attr("checked") === "checked") {
        return this._checkAllCheckboxes();
      } else {
        return this._uncheckAllCheckboxes();
      }
    };

    CheckboxToggler.prototype._uncheckToggleAllCheckbox = function() {
      return this.toggle_all_checkbox.removeAttr("checked");
    };

    CheckboxToggler.prototype._checkToggleAllCheckbox = function() {
      return this.toggle_all_checkbox.attr("checked", "checked");
    };

    CheckboxToggler.prototype._uncheckAllCheckboxes = function() {
      var _this = this;
      return this.checkboxes.each(function(index, el) {
        $(el).removeAttr("checked");
        return _this._didChangeCheckbox(el);
      });
    };

    CheckboxToggler.prototype._checkAllCheckboxes = function() {
      var _this = this;
      return this.checkboxes.each(function(index, el) {
        $(el).attr("checked", "checked");
        return _this._didChangeCheckbox(el);
      });
    };

    return CheckboxToggler;

  })();

  (function($) {
    return $.widget.bridge('checkboxToggler', AA.CheckboxToggler);
  })(jQuery);

}).call(this);
