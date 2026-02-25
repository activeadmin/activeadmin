import Rails from '@rails/ujs';

let activeModal = null
let backdrop = null

const open = function(modal) {
  modal.classList.remove("hidden")
  modal.classList.add("flex", "justify-center", "items-center")
  modal.removeAttribute("aria-hidden")
  modal.setAttribute("aria-modal", "true")
  modal.setAttribute("role", "dialog")
  document.body.classList.add("overflow-hidden")

  backdrop = document.createElement("div")
  backdrop.className = "fixed inset-0 z-40 bg-gray-900/50 dark:bg-gray-900/80";
  backdrop.setAttribute("data-modal-backdrop", "")
  document.body.appendChild(backdrop)

  activeModal = modal
}

const close = function() {
  if (!activeModal) { return }
  activeModal.classList.add("hidden")
  activeModal.classList.remove("flex", "justify-center", "items-center")
  activeModal.setAttribute("aria-hidden", "true")
  activeModal.removeAttribute("aria-modal")
  activeModal.removeAttribute("role")
  document.body.classList.remove("overflow-hidden")

  if (backdrop) {
    backdrop.remove()
    backdrop = null
  }

  activeModal = null
}

const showClick = function(event) {
  event.preventDefault()
  const id = this.dataset.modalShow
  const modal = document.getElementById(id)
  if (!modal) { return }
  close()
  open(modal)
}

const hideClick = function(event) {
  event.preventDefault()
  close()
}

const backdropClick = function(event) {
  if (event.target.hasAttribute("data-modal-backdrop")) { close() }
}

const escapeKey = function(event) {
  if (event.key === "Escape") { close() }
}

Rails.delegate(document, "[data-modal-show]", "click", showClick)
Rails.delegate(document, "[data-modal-hide]", "click", hideClick)
document.addEventListener("click", backdropClick)
document.addEventListener("keydown", escapeKey)
