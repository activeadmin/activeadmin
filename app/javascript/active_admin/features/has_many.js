import { delegate } from "@rails/ujs";

const hasManyRemoveClick = function(event) {
  event.preventDefault()
  const oldGroup = this.closest("fieldset")
  if (oldGroup) {
    oldGroup.remove()
  }
}

delegate(document, "a.button.has_many_remove", "click", hasManyRemoveClick)

const hasManyAddClick = function(event) {
  event.preventDefault()
  const parent = this.closest(".has_many_container")

  let index = parseInt(parent.dataset.has_many_index || (parent.querySelectorAll('fieldset').length - 1))
  parent.dataset.has_many_index = ++index

  const regex = new RegExp(this.dataset.placeholder, 'g')
  const html = this.dataset.html.replace(regex, index)

  const tempEl = document.createElement("div");
  tempEl.innerHTML = html
  this.before(tempEl.firstChild)
}

delegate(document, "a.button.has_many_add", "click", hasManyAddClick)
