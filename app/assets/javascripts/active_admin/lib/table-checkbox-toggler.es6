ActiveAdmin.TableCheckboxToggler = class TableCheckboxToggler extends ActiveAdmin.CheckboxToggler {
  _bind() {
    super._bind(...arguments);

    this.$container
      .find('tbody td')
      .click(event => {
        if (event.target.type !== 'checkbox') {
          this._didClickCell(event.target);
        }
      });
  }

  _didChangeCheckbox(checkbox) {
    super._didChangeCheckbox(...arguments);

    $(checkbox)
      .parents('tr')
      .toggleClass('selected', checkbox.checked);
  }

  _didChangeToggleAllCheckbox() {
    this.$container
      .find('tbody tr')
      .toggleClass('selected', super._didChangeToggleAllCheckbox(...arguments));
  }

  _didClickCell(cell) {
    $(cell)
      .parent('tr')
      .find(':checkbox')
      .click();
  }
};

$.widget.bridge('tableCheckboxToggler', ActiveAdmin.TableCheckboxToggler);
