import Rails from '@rails/ujs';
import { autoUpdate, computePosition, flip, offset } from '@floating-ui/dom';

let activeDropdown = null

const position = function(toggle, menu) {
  const placement = toggle.dataset.dropdownPlacement || "bottom-start"
  const distance = parseInt(toggle.dataset.dropdownOffsetDistance, 10) || 0

  computePosition(toggle, menu, {
    placement: placement,
    middleware: [offset(distance), flip()]
  }).then(({x, y}) => {
    Object.assign(menu.style, {
      position: 'absolute',
      left: `${x}px`,
      top: `${y}px`,
    });
  })
}

const open = function(toggle, menu) {
  menu.classList.remove("hidden")
  menu.classList.add("block")
  position(toggle, menu)

  const cleanupAutoUpdate = autoUpdate(toggle, menu, () => {
    position(toggle, menu)
  })

  activeDropdown = {
    toggle: toggle,
    menu: menu,
    cleanupAutoUpdate: cleanupAutoUpdate,
  }
}

const close = function() {
  if (!activeDropdown) { return }
  activeDropdown.menu.classList.remove("block")
  activeDropdown.menu.classList.add("hidden")
  activeDropdown.cleanupAutoUpdate()
  activeDropdown = null
}

const toggleClick = function(event) {
  event.preventDefault()
  const menu = document.getElementById(this.dataset.dropdownToggle)
  if (!menu) { return }

  if (activeDropdown && activeDropdown.menu === menu) {
    close()
  } else {
    close()
    open(this, menu)
  }
}

const outsideClick = function(event) {
  if (!activeDropdown) { return }
  if (activeDropdown.toggle.contains(event.target)) { return }
  if (activeDropdown.menu.contains(event.target)) { return }
  close()
}

const escapeKey = function(event) {
  if (event.key === "Escape") { close() }
}

Rails.delegate(document, "[data-dropdown-toggle]", "click", toggleClick)
document.addEventListener("click", outsideClick)
document.addEventListener("keydown", escapeKey)
