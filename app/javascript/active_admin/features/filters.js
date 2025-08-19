import Rails from '@rails/ujs';
import { nextSibling } from 'active_admin/utils/dom'

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

const clearFiltersForm = function(event) {
  event.preventDefault()

  const regex = /^(q\[|page|utf8|commit)/
  const params = new URLSearchParams(window.location.search)

  Array.from(params.keys())
    .filter(k => k.match(regex))
    .forEach(k => params.delete(k))

  window.location.search = params.toString()
}

Rails.delegate(document, ".filters-form-clear", "click", clearFiltersForm)
