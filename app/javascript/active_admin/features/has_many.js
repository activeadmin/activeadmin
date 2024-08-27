import Rails from '@rails/ujs';

const hasManyRemoveClick = function(event) {
  event.preventDefault()
  const oldGroup = this.closest("fieldset")
  if (oldGroup) {
    oldGroup.remove()
  }
}

Rails.delegate(document, "form .has-many-remove", "click", hasManyRemoveClick)

const hasManyAddClick = function(event) {
  event.preventDefault()
  const parent = this.closest(".has-many-container")

  let index = parseInt(parent.dataset.has_many_index || (parent.querySelectorAll('fieldset').length - 1), 10)
  parent.dataset.has_many_index = ++index

  const regex = new RegExp(this.dataset.placeholder, 'g')
  const html = this.dataset.html.replace(regex, index)

  const tempEl = document.createElement("div");
  tempEl.innerHTML = html
  this.before(tempEl.firstChild)
}

Rails.delegate(document, "form .has-many-add", "click", hasManyAddClick)
