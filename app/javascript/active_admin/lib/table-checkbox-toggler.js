import CheckboxToggler from "./checkbox-toggler";

class TableCheckboxToggler extends CheckboxToggler {
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

export default TableCheckboxToggler;
