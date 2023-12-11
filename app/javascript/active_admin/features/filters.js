import Rails from '@rails/ujs';

const disableEmptyFields = function(event) {
  Array.from(this.querySelectorAll("input, select, textarea"))
    .filter((el) => el.value === "")
    .forEach((el) => el.disabled = true)
};

Rails.delegate(document, ".filters-form", "submit", disableEmptyFields)

const next = function next(el, selector) {
  const nextEl = el.nextElementSibling;
  if (!selector || (nextEl && nextEl.matches(selector))) {
    return nextEl;
  }
  return null;
}

const setSearchType = function(event) {
  const input = next(this, "input")
  if (input) {
    input.name = `q[${this.value}]`
  }
};

Rails.delegate(document, ".filters-form-field [data-search-methods]", "change", setSearchType)
