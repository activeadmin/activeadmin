(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  window.AA.TableCheckboxToggler = AA.TableCheckboxToggler = (function(_super) {

    __extends(TableCheckboxToggler, _super);

    function TableCheckboxToggler() {
      TableCheckboxToggler.__super__.constructor.apply(this, arguments);
    }

    TableCheckboxToggler.prototype._init = function() {
      return TableCheckboxToggler.__super__._init.apply(this, arguments);
    };

    TableCheckboxToggler.prototype._bind = function() {
      var _this = this;
      TableCheckboxToggler.__super__._bind.apply(this, arguments);
      return this.$container.find("tbody").find("td").bind("click", function(e) {
        if (e.target.type !== 'checkbox') return _this._didClickCell(e.target);
      });
    };

    TableCheckboxToggler.prototype._didChangeCheckbox = function(checkbox) {
      var $row;
      TableCheckboxToggler.__super__._didChangeCheckbox.apply(this, arguments);
      $row = $(checkbox).parents("tr");
      if (checkbox.checked) {
        return $row.addClass("selected");
      } else {
        return $row.removeClass("selected");
      }
    };

    TableCheckboxToggler.prototype._didClickCell = function(cell) {
      return $(cell).parent("tr").find(':checkbox').click();
    };

    return TableCheckboxToggler;

  })(AA.CheckboxToggler);

  (function($) {
    return $.widget.bridge('tableCheckboxToggler', AA.TableCheckboxToggler);
  })(jQuery);

}).call(this);
