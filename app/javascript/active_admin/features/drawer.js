import Rails from '@rails/ujs';

let activeDrawer = null
let backdrop = null

const open = function(drawer) {
  drawer.classList.remove("-translate-x-full")
  drawer.classList.add("translate-x-0")
  drawer.setAttribute("aria-modal", "true")
  drawer.setAttribute("role", "dialog")
  document.body.classList.add("overflow-hidden", "xl:overflow-auto")

  backdrop = document.createElement("div")
  backdrop.className = "fixed inset-0 z-30 bg-gray-900/50 dark:bg-gray-900/80";
  backdrop.setAttribute("data-drawer-backdrop", "")
  document.body.appendChild(backdrop)

  activeDrawer = drawer
}

const close = function() {
  if (!activeDrawer) { return }
  activeDrawer.classList.add("-translate-x-full")
  activeDrawer.classList.remove("translate-x-0")
  activeDrawer.removeAttribute("aria-modal")
  activeDrawer.removeAttribute("role")
  document.body.classList.remove("overflow-hidden", "xl:overflow-auto")

  if (backdrop) {
    backdrop.remove()
    backdrop = null
  }

  activeDrawer = null
}

const showClick = function(event) {
  event.preventDefault()
  const id = this.dataset.drawerShow
  const drawer = document.getElementById(id)
  if (!drawer) { return }

  close()
  open(drawer)
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
    open(drawer)
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
  if (event.target.hasAttribute("data-drawer-backdrop")) { close() }
}

const escapeKey = function(event) {
  if (event.key === "Escape") { close() }
}

Rails.delegate(document, "[data-drawer-show]", "click", showClick)
Rails.delegate(document, "[data-drawer-toggle]", "click", toggleClick)
Rails.delegate(document, "[data-drawer-hide], [data-drawer-dismiss]", "click", hideClick)
document.addEventListener("click", backdropClick)
document.addEventListener("keydown", escapeKey)
