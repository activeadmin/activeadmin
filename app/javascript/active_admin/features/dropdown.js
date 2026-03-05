import Rails from '@rails/ujs';
import { autoUpdate, computePosition, flip, offset } from '@floating-ui/dom';

let activeDropdown = null

const menuItems = function(menu) {
  return menu.querySelectorAll('a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])')
}

const setExpanded = function(toggle, expanded) {
  toggle.setAttribute('aria-expanded', expanded ? 'true' : 'false')
}

const position = function(toggle, menu) {
  const placement = toggle.dataset.dropdownPlacement || "bottom-start"
  const distance = parseInt(toggle.dataset.dropdownOffsetDistance, 10) || 0

  computePosition(toggle, menu, {
    placement: placement,
    middleware: [offset(distance), flip()]
  }).then(({x, y}) => {
    Object.assign(menu.style, {
      position: "absolute",
      left: `${x}px`,
      top: `${y}px`,
    });
  })
}

const open = function(toggle, menu) {
  setExpanded(toggle, true)
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
  const { toggle, menu, cleanupAutoUpdate } = activeDropdown

  setExpanded(toggle, false)
  activeDropdown.menu.classList.remove("block")
  activeDropdown.menu.classList.add("hidden")
  cleanupAutoUpdate()
  activeDropdown = null

  if (document.activeElement && menu.contains(document.activeElement)) {
    toggle.focus()
  }
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

const toggleKeydown = function(event) {
  if (event.key !== 'Enter' && event.key !== ' ' && event.key !== 'ArrowDown' && event.key !== 'Escape') {
    return
  }

  const menu = document.getElementById(this.dataset.dropdownToggle)
  if (!menu) { return }

  if (event.key === 'Escape') {
    if (activeDropdown && activeDropdown.menu === menu) {
      event.preventDefault()
      close()
    }

    return
  }

  event.preventDefault()

  if (activeDropdown && activeDropdown.menu === menu) {
    close()
    return
  }

  close()
  open(this, menu)

  const items = menuItems(menu)
  if (items.length > 0) {
    items[0].focus()
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
Rails.delegate(document, "[data-dropdown-toggle]", "keydown", toggleKeydown)
document.addEventListener("click", outsideClick)
document.addEventListener("keydown", escapeKey)
