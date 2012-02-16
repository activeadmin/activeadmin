(function() {

  window.AA = {};

}).call(this);
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
(function() {

  window.AA.Popover = AA.Popover = (function() {

    function Popover(options, element) {
      var defaults;
      this.options = options;
      this.element = element;
      this.$element = $(this.element);
      defaults = {
        fadeInDuration: 20,
        fadeOutDuration: 100,
        autoOpen: true,
        pageWrapperElement: "#wrapper",
        onClickActionItemCallback: null
      };
      this.options = $.extend({}, defaults, options);
      this.$popover = null;
      this.isOpen = false;
      if ($(this.$element.attr("href")).length > 0) {
        this.$popover = $(this.$element.attr("href"));
      }
      this._buildPopover();
      this._bind();
      return this;
    }

    Popover.prototype.open = function() {
      this.isOpen = true;
      this.$popover.fadeIn(this.options.fadeInDuration);
      this._positionPopover();
      this._positionNipple();
      return this;
    };

    Popover.prototype.close = function() {
      this.isOpen = false;
      this.$popover.fadeOut(this.options.fadeOutDuration);
      return this;
    };

    Popover.prototype.destroy = function() {
      this.$element.removeData('popover');
      this.$element.unbind();
      this.$element = null;
      return this;
    };

    Popover.prototype.option = function() {};

    Popover.prototype._buildPopover = function() {
      this.$popover.prepend("<div class=\"popover_nipple\"></div>");
      this.$popover.hide();
      return this.$popover.addClass("popover");
    };

    Popover.prototype._bind = function() {
      var _this = this;
      $(this.options.pageWrapperElement).bind('click', function(e) {
        if (_this.isOpen === true) return _this.close();
      });
      if (this.options.autoOpen === true) {
        return this.$element.bind('click', function() {
          _this.open();
          return false;
        });
      }
    };

    Popover.prototype._positionPopover = function() {
      var centerOfButtonFromLeft, centerOfPopoverFromLeft, popoverLeftPos;
      centerOfButtonFromLeft = this.$element.offset().left + this.$element.outerWidth() / 2;
      centerOfPopoverFromLeft = this.$popover.outerWidth() / 2;
      popoverLeftPos = centerOfButtonFromLeft - centerOfPopoverFromLeft;
      return this.$popover.css("left", popoverLeftPos);
    };

    Popover.prototype._positionNipple = function() {
      var $nipple, bottomOfButtonFromTop, centerOfPopoverFromLeft, centerOfnippleFromLeft, nippleLeftPos;
      centerOfPopoverFromLeft = this.$popover.outerWidth() / 2;
      bottomOfButtonFromTop = this.$element.offset().top + this.$element.outerHeight() + 10;
      this.$popover.css("top", bottomOfButtonFromTop);
      $nipple = this.$popover.find(".popover_nipple");
      centerOfnippleFromLeft = $nipple.outerWidth() / 2;
      nippleLeftPos = centerOfPopoverFromLeft - centerOfnippleFromLeft;
      return $nipple.css("left", nippleLeftPos);
    };

    return Popover;

  })();

  (function($) {
    return $.widget.bridge('popover', AA.Popover);
  })(jQuery);

}).call(this);
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
(function() {

  $(function() {
    $(".datepicker").datepicker({
      dateFormat: "yy-mm-dd"
    });
    return $(".clear_filters_btn").click(function() {
      window.location.search = "";
      return false;
    });
  });

}).call(this);
(function() {

  jQuery(function($) {
    $("#batch_actions_button").popover({
      autoOpen: false
    });
    $(document).delegate("#batch_actions_popover li a", "click.rails", function() {
      $("#batch_action").val($(this).attr("data-action"));
      return $("#collection_selection").submit();
    });
    $("#batch_actions_button").click(function() {
      if (!$(this).hasClass("disabled")) {
        if ($("#batch_actions_popover").is(":hidden")) {
          $(this).popover("open");
          return false;
        } else {
          $(this).popover("close");
          return false;
        }
      }
    });
    if ($("#batch_actions_button").length && $(":checkbox.toggle_all").length) {
      if ($(".paginated_collection").find("table").length) {
        $(".paginated_collection table").tableCheckboxToggler();
      } else {
        $(".paginated_collection").checkboxToggler();
      }
      return $(".paginated_collection").find(":checkbox").bind("change", function() {
        if ($(".paginated_collection").find(":checkbox").filter(":checked").length > 0) {
          return $("#batch_actions_button").removeClass("disabled");
        } else {
          return $("#batch_actions_button").addClass("disabled");
        }
      });
    }
  });

}).call(this);




