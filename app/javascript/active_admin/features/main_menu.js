import Rails from '@rails/ujs';
import { nextSibling } from '../utils/dom'

const toggleMenu = function(event) {
  const parent = this.parentNode
  const menu = nextSibling(this, "[data-menu-list]")
  if (!("open" in parent.dataset)) {
    parent.dataset.open = ""
    menu.classList.remove("hidden")
    this.querySelector("[data-menu-icon]").classList.add("rotate-90")
  } else {
    delete parent.dataset.open
    menu.classList.add("hidden")
    this.querySelector("[data-menu-icon]").classList.remove("rotate-90")
  }
}

Rails.delegate(document, "#main-menu [data-menu-button]", "click", toggleMenu)
