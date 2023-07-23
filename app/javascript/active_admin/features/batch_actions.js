import { delegate } from "@rails/ujs";

const batchActionClick = function(event) {
  event.preventDefault()
  // console.log("batchActionClick", event)
  let batchAction = document.getElementById("batch_action")
  if (batchAction)
    batchAction.value = this.dataset.action
}

const batchActionConfirmComplete = function(event) {
  // console.log('batchActionConfirmComplete', event.detail)
  if (event.detail[0] === true) {
    let form = document.getElementById("collection_selection")
    if (form) {
      form.submit()
    }
  }
}

const batchActionFormSubmit = function(event) {
  event.preventDefault();
  // console.log("batchActionFormSubmit", this)
  let json = JSON.stringify(Object.fromEntries(new FormData(this).entries()));
  let inputsField = document.getElementById('batch_action_inputs')
  if (json && inputsField) {
    inputsField.value = json
  }
  let form = document.getElementById("collection_selection")
  if (form) {
    form.submit()
  }
}

delegate(document, ".batch_actions_selector li a", "click", batchActionClick)

delegate(document, "form.batch-action-form", "submit", batchActionFormSubmit)

delegate(document, ".batch_actions_selector li a", "confirm:complete", batchActionConfirmComplete)

const toggleDropdown = function(condition) {
  const button = document.querySelector(".batch_actions_selector > button")
  if (button) {
    button.disabled = condition
  }
}

const toggleAllChange = function(event) {
  const checkboxes = document.querySelectorAll("input[type=checkbox].collection_selection")
  for (const checkbox of checkboxes) {
    checkbox.checked = this.checked
  }

  const rows = document.querySelectorAll(".paginated_collection tbody tr")
  for (const row of rows) {
    row.classList.toggle("selected", this.checked);
  }

  toggleDropdown(!this.checked)
}

delegate(document, "input[type=checkbox].toggle_all", "change", toggleAllChange)

const toggleCheckboxChange = function(event) {
  const numChecked = document.querySelectorAll("input[type=checkbox].collection_selection:checked").length;
  const allChecked = numChecked === document.querySelectorAll("input[type=checkbox].collection_selection").length;
  const someChecked = (numChecked > 0) && (numChecked < document.querySelectorAll("input[type=checkbox].collection_selection").length);

  const toggleAll = document.querySelector("input[type=checkbox].toggle_all")
  if (toggleAll) {
    toggleAll.checked = allChecked
    toggleAll.indeterminate = someChecked
  }

  toggleDropdown(numChecked === 0)
}

delegate(document, "input[type=checkbox].collection_selection", "change", toggleCheckboxChange)

const tableRowClick = function(event) {
  if (event.target.type !== "checkbox") {
    event.target.closest("tr").querySelector("input[type=checkbox]").click()
  }
}

delegate(document, ".paginated_collection tbody td", "click", tableRowClick)
