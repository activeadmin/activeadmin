import Rails from '@rails/ujs';

const toggleMenu = function(event) {
  const parent = this.parentNode
  if (!("open" in parent.dataset)) {
    parent.dataset.open = ""
  } else {
    delete parent.dataset.open
  }
}

Rails.delegate(document, "#main-menu [data-menu-button]", "click", toggleMenu)
