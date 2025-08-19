import Rails from '@rails/ujs';

const submitForm = function() {
  let form = document.getElementById("collection_selection")
  if (form) {
    form.submit()
  }
}

const batchActionClick = function(event) {
  event.preventDefault()
  let batchAction = document.getElementById("batch_action")
  if (batchAction) {
    batchAction.value = this.dataset.action
  }

  if (!event.target.dataset.confirm && !event.target.dataset.modalTarget) { submitForm() }
}

const batchActionConfirmComplete = function(event) {
  event.preventDefault()
  if (event.detail[0] === true) {
    let batchAction = document.getElementById("batch_action")
    if (batchAction) {
      batchAction.value = this.dataset.action
    }
    submitForm()
  }
}

const batchActionFormSubmit = function(event) {
  event.preventDefault();
  let json = JSON.stringify(Object.fromEntries(new FormData(this).entries()));
  let inputsField = document.getElementById('batch_action_inputs')
  let form = document.getElementById("collection_selection")
  if (json && inputsField && form) {
    inputsField.value = json
    form.submit()
  }
}

Rails.delegate(document, "[data-batch-action-item]", "confirm:complete", batchActionConfirmComplete)
Rails.delegate(document, "[data-batch-action-item]", "click", batchActionClick)
Rails.delegate(document, "form[data-batch-action-form]", "submit", batchActionFormSubmit)

const disableDropdown = function(condition) {
  const button = document.querySelector(".batch-actions-dropdown-toggle")
  if (button) {
    button.disabled = condition
  }
}

const toggleAllChange = function(event) {
  const checkboxes = document.querySelectorAll(".batch-actions-resource-selection")
  for (const checkbox of checkboxes) {
    checkbox.checked = this.checked
  }

  const rows = document.querySelectorAll(".paginated-collection tbody tr")
  for (const row of rows) {
    row.classList.toggle("selected", this.checked);
  }

  disableDropdown(!this.checked)
}

Rails.delegate(document, ".batch-actions-toggle-all", "change", toggleAllChange)

const toggleCheckboxChange = function(event) {
  const numChecked = document.querySelectorAll(".batch-actions-resource-selection:checked").length;
  const allChecked = numChecked === document.querySelectorAll(".batch-actions-resource-selection").length;
  const someChecked = (numChecked > 0) && (numChecked < document.querySelectorAll(".batch-actions-resource-selection").length);

  const toggleAll = document.querySelector(".batch-actions-toggle-all")
  if (toggleAll) {
    toggleAll.checked = allChecked
    toggleAll.indeterminate = someChecked
  }

  disableDropdown(numChecked === 0)
}

Rails.delegate(document, ".batch-actions-resource-selection", "change", toggleCheckboxChange)

const tableRowClick = function(event) {
  const type = event.target.type;
  if (typeof type === "undefined" || (type !== "checkbox" && type !== "button" && type !== "")) {
    const checkbox = event.target.closest("tr").querySelector("input[type=checkbox]")
    if (checkbox) {
      checkbox.click()
    }
  }
}

Rails.delegate(document, ".paginated-collection tbody td", "click", tableRowClick)
