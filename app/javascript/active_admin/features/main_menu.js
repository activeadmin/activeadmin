import Rails from '@rails/ujs';

const toggleMenu = function() {
  const parent = this.closest([`[data-item-id="${this.dataset.parentId}"]`])

  if (!("open" in parent.dataset)) {
    parent.dataset.open = ""
  } else {
    delete parent.dataset.open
  }
}

Rails.delegate(document, "#main-menu [data-menu-button]", "click", toggleMenu)
