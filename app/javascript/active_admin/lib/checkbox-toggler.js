class CheckboxToggler {
  constructor(options, container){
    this.options = options;
    this.container = container;
    this._init();
    this._bind();
  }

  option(_key, _value) {
  }

  _init() {
    if (!this.container) {
      throw new Error('Container element not found');
    } else {
      this.$container = $(this.container);
    }

    if (!this.$container.find('.toggle_all').length) {
      throw new Error('"toggle all" checkbox not found');
    } else {
      this.toggle_all_checkbox = this.$container.find('.toggle_all');
    }

    this.checkboxes = this.$container.find(':checkbox').not(this.toggle_all_checkbox);
  }

  _bind() {
    this.checkboxes.change(event => this._didChangeCheckbox(event.target));
    this.toggle_all_checkbox.change(() => this._didChangeToggleAllCheckbox());
  }

  _didChangeCheckbox(_checkbox){
    const numChecked = this.checkboxes.filter(':checked').length;

    const allChecked = numChecked === this.checkboxes.length;
    const someChecked = (numChecked > 0) && (numChecked < this.checkboxes.length);

    this.toggle_all_checkbox.prop({ checked: allChecked, indeterminate: someChecked });
  }

  _didChangeToggleAllCheckbox() {
    const setting = this.toggle_all_checkbox.prop('checked');
    this.checkboxes.prop({ checked: setting });
    return setting;
  }
}

export default CheckboxToggler;
