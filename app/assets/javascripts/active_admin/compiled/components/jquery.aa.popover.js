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
