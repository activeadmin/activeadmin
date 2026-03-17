import Rails from '@rails/ujs';
import { trapFocus, focusFirstDescendant } from 'active_admin/utils/focus_trap';

let activeModal = null
let triggerElement = null
let backdrop = null
let cleanupTrap = null

const escapeKey = function(event) {
  if (event.key !== "Escape") { return }
  if (event.currentTarget !== activeModal) { return }

  event.preventDefault()
  event.stopPropagation()
  close()
}

const open = function(modal, trigger) {
  triggerElement = trigger

  modal.classList.remove("hidden")
  modal.classList.add("flex", "justify-center", "items-center")
  modal.removeAttribute("aria-hidden")
  modal.setAttribute("aria-modal", "true")
  modal.setAttribute("role", "dialog")

  document.body.classList.add("overflow-hidden")

  backdrop = document.createElement("div")
  backdrop.className = "fixed inset-0 z-40 bg-gray-900/50 dark:bg-gray-900/80"
  backdrop.setAttribute("data-modal-backdrop", "")
  document.body.appendChild(backdrop)

  activeModal = modal
  activeModal.addEventListener("click", backdropClick)
  activeModal.addEventListener("keydown", escapeKey)
  cleanupTrap = trapFocus(modal)
  focusFirstDescendant(modal)
}

const close = function() {
  if (!activeModal) { return }

  activeModal.removeEventListener("click", backdropClick)
  activeModal.removeEventListener("keydown", escapeKey)
  activeModal.classList.add("hidden")
  activeModal.classList.remove("flex", "justify-center", "items-center")
  activeModal.setAttribute("aria-hidden", "true")
  activeModal.removeAttribute("aria-modal")
  activeModal.removeAttribute("role")
  document.body.classList.remove("overflow-hidden")
  backdrop.remove()
  cleanupTrap()

  activeModal = null
  backdrop = null
  cleanupTrap = null

  if (triggerElement && triggerElement.isConnected) { triggerElement.focus() }
  triggerElement = null
}

const showClick = function(event) {
  event.preventDefault()
  const id = this.dataset.modalShow
  const modal = document.getElementById(id)
  if (!modal) { return }
  close()
  open(modal, this)
}

const hideClick = function(event) {
  event.preventDefault()
  close()
}

const backdropClick = function(event) {
  if (event.currentTarget !== activeModal) { return }
  if (event.target === activeModal) { close() }
}

Rails.delegate(document, "[data-modal-show]", "click", showClick)
Rails.delegate(document, "[data-modal-hide]", "click", hideClick)
