import { delegate } from "@rails/ujs";
import { next } from "../utils/dom"

const disableEmptyFields = function(_event) {
  Array.from(this.querySelectorAll("input, select, textarea"))
    .filter((el) => el.value === "")
    .forEach((el) => el.disabled = true)
};

delegate(document, ".filter_form", "submit", disableEmptyFields)

const setSearchType = function(_event) {
  const input = next(this, "input")
  if (input) {
    input.name = `q[${this.value}]`
  }
};

delegate(document, ".filter_form_field.select_and_search select", "change", setSearchType)
