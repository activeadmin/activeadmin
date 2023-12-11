import Rails from '@rails/ujs';
import { nextSibling } from '../utils/dom'

const disableEmptyFields = function(event) {
  Array.from(this.querySelectorAll("input, select, textarea"))
    .filter((el) => el.value === "")
    .forEach((el) => el.disabled = true)
};

Rails.delegate(document, ".filters-form", "submit", disableEmptyFields)

const setSearchType = function(event) {
  const input = nextSibling(this, "input")
  if (input) {
    input.name = `q[${this.value}]`
  }
};

Rails.delegate(document, ".filters-form-field [data-search-methods]", "change", setSearchType)
