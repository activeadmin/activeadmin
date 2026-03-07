import Rails from '@rails/ujs';
import { trapFocus, focusFirstDescendant } from 'active_admin/utils/focus_trap';

let activeDrawer = null
let triggerElement = null
let backdrop = null
let cleanupTrap = null

const escapeKey = function(event) {
  if (event.key !== "Escape") { return }
  if (event.currentTarget !== activeDrawer) { return }

  event.preventDefault()
  event.stopPropagation()
  close()
}

const open = function(drawer, trigger) {
  triggerElement = trigger

  drawer.classList.remove("-translate-x-full")
  drawer.classList.add("translate-x-0")
  drawer.setAttribute("aria-modal", "true")
  drawer.setAttribute("role", "dialog")

  document.body.classList.add("overflow-hidden", "xl:overflow-auto")

  backdrop = document.createElement("div")
  backdrop.className = "fixed inset-0 z-30 bg-gray-900/50 dark:bg-gray-900/80"
  backdrop.setAttribute("data-drawer-backdrop", "")
  backdrop.addEventListener("click", backdropClick)
  document.body.appendChild(backdrop)

  activeDrawer = drawer
  activeDrawer.addEventListener("keydown", escapeKey)
  cleanupTrap = trapFocus(drawer)
  focusFirstDescendant(drawer)
}

const close = function() {
  if (!activeDrawer) { return }

  backdrop.removeEventListener("click", backdropClick)
  activeDrawer.removeEventListener("keydown", escapeKey)
  activeDrawer.classList.add("-translate-x-full")
  activeDrawer.classList.remove("translate-x-0")
  activeDrawer.removeAttribute("aria-modal")
  activeDrawer.removeAttribute("role")
  document.body.classList.remove("overflow-hidden", "xl:overflow-auto")
  backdrop.remove()
  cleanupTrap()

  activeDrawer = null
  backdrop = null
  cleanupTrap = null

  if (triggerElement && triggerElement.isConnected) { triggerElement.focus() }
  triggerElement = null
}

const showClick = function(event) {
  event.preventDefault()
  const id = this.dataset.drawerShow
  const drawer = document.getElementById(id)
  if (!drawer) { return }
  close()
  open(drawer, this)
}

const toggleClick = function(event) {
  event.preventDefault()
  const id = this.dataset.drawerToggle
  const drawer = document.getElementById(id)
  if (!drawer) { return }

  if (activeDrawer === drawer) {
    close()
  } else {
    close()
    open(drawer, this)
  }
}

const hideClick = function(event) {
  event.preventDefault()
  const id = this.dataset.drawerHide || this.dataset.drawerDismiss

  if (!id) {
    close()
    return
  }

  const drawer = document.getElementById(id)
  if (!drawer) { return }
  if (activeDrawer !== drawer) { return }

  close()
}

const backdropClick = function(event) {
  if (event.currentTarget === backdrop) { close() }
}

Rails.delegate(document, "[data-drawer-show]", "click", showClick)
Rails.delegate(document, "[data-drawer-toggle]", "click", toggleClick)
Rails.delegate(document, "[data-drawer-hide], [data-drawer-dismiss]", "click", hideClick)
