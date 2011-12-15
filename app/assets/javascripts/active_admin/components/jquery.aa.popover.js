;( function($, window, document, undefined) {
  function AAPopover(options, element) {
    this.element = element;
    this.$element = $(element);

    var defaults = {
      fadeInDuration: 20,
      fadeOutDuration: 100,
      autoOpen: true,
      pageWrapperElement: "#wrapper",
      onClickActionItemCallback: null
    }

    this.options = $.extend( {}, defaults, options);

    this._init();
  }

  AAPopover.prototype._init = function() {
    var that = this;

    this.$popover = null;
    this.isOpen = false;

    if ($(this.$element.attr("href")).length > 0) {
      this.$popover = $(this.$element.attr("href"));
    }
    
    this._buildPopover();
    this._bind();
  }

  AAPopover.prototype.open = function() {
    this.isOpen = true;
    this.$popover.fadeIn(this.options.fadeInDuration);
    
    this._positionPopover();
    this._positionNipple();
  }

  AAPopover.prototype.close = function() {
    this.isOpen = false;
    this.$popover.fadeOut(this.options.fadeOutDuration);
  }

  AAPopover.prototype.destroy = function() {
    this.$element.removeData('aaPopover');
    this.$element.unbind();
    this.$element = null;
  }

  AAPopover.prototype.option = function() {
    // Need to implement this for jQueryUI.bridge for some reason
  }

  AAPopover.prototype._positionPopover = function() {
    var centerOfButtonFromLeft = this.$element.offset().left + this.$element.outerWidth() / 2;
    var centerOfPopoverFromLeft = this.$popover.outerWidth() / 2;
    var popoverLeftPos = centerOfButtonFromLeft - centerOfPopoverFromLeft;
    this.$popover.css('left', popoverLeftPos);
  }

  AAPopover.prototype._positionNipple = function() {
    var centerOfPopoverFromLeft = this.$popover.outerWidth() / 2;
    var bottomOfButtonFromTop = this.$element.offset().top + this.$element.outerHeight() + 10;
    this.$popover.css('top',  bottomOfButtonFromTop);
    var $nipple = this.$popover.find(".popover_nipple");
    var centerOfnippleFromLeft = $nipple.outerWidth() / 2;
    
    var nippleLeftPos = centerOfPopoverFromLeft - centerOfnippleFromLeft;
    
    $nipple.css('left', nippleLeftPos)
  }

  AAPopover.prototype._buildPopover = function() {
    this.$popover.prepend("<div class=\"popover_nipple\"></div>");

    this.$popover.hide();

    this.$popover.addClass("popover");
  }

  AAPopover.prototype._bind = function() {
    var that = this;
    
    $(this.options.pageWrapperElement).bind('click', function(e) {
      if (that.isOpen == true) {
        that.close();
      };
    });

    if (this.options.autoOpen == true) {
      this.$element.bind('click', function(){
        that.open();
        return false;
      });
    };

    this.$popover.find("a").bind('click', function() {
      if (that.options.onClickActionItemCallback && typeof that.options.onClickActionItemCallback === 'function') {
        that.options.onClickActionItemCallback.call(this);
      }
    });
  };
    
  // Register as a jQuery plugin
	$.widget.bridge('aaPopover', AAPopover);

})( jQuery, window, document );

