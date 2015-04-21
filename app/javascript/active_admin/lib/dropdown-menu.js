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
    this.isOpen  = false;

    this.$menuButton = this.$element.find('.button');
    this.$menuList   = this.$element.find('.dropdown-menu');

    this._buildMenuList();
    this._bind();
  }

  open() {
    this.isOpen = true;
    this.$menuList.fadeIn(this.options.fadeInDuration);
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
    return this.$menuButton.hasClass('disabled');
  }

  disable() {
    this.$menuButton.addClass('disabled');
  }

  enable() {
    this.$menuButton.removeClass('disabled');
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
    this.$menuList.hide();
  }

  _bind() {
    $('body').click(() => {
      if (this.isOpen) { this.close(); }
    });

    this.$menuButton.click(() => {
      if (!this.isDisabled()) {
        if (this.isOpen) {
          this.close();
        } else {
          this.open();
        }
      }
      return false;
    });
  }
}

export default DropdownMenu;
