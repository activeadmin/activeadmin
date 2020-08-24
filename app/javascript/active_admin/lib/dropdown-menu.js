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

    this.$menuButton = this.$element.find('.dropdown_menu_button');
    this.$menuList   = this.$element.find('.dropdown_menu_list_wrapper');

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
    this.$nipple = $('<div class="dropdown_menu_nipple"></div>');
    this.$menuList.prepend(this.$nipple);
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

  _position() {
    this.$menuList.css('top', this.$menuButton.position().top + this.$menuButton.outerHeight() + 10);

    const button_left = this.$menuButton.position().left;
    const button_center =  this.$menuButton.outerWidth() / 2;
    const button_right = button_left + (button_center * 2);
    const menu_center = this.$menuList.outerWidth() / 2;
    const nipple_center = this.$nipple.outerWidth() / 2;
    const window_right = $(window).width();

    const centered_menu_left = (button_left + button_center) - menu_center;
    const centered_menu_right = button_left + button_center + menu_center;

    if (centered_menu_left < 0) {
      // Left align with button
      this.$menuList.css('left', button_left);
      this.$nipple.css('left', button_center - nipple_center);
    } else if (centered_menu_right > window_right) {
      // Right align with button
      this.$menuList.css('right', window_right - button_right);
      this.$nipple.css('right', button_center - nipple_center);
    } else {
      // Center align under button
      this.$menuList.css('left', centered_menu_left);
      this.$nipple.css('left', menu_center - nipple_center);
    }
  }
}

export default DropdownMenu;
