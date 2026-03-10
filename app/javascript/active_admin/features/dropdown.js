import Rails from '@rails/ujs';
import { autoUpdate, computePosition, flip, offset } from '@floating-ui/dom';

let activeDropdown = null

const FOCUS_DIRECTIONS = {
  ArrowDown: "next",
  ArrowUp: "prev",
  Home: "first",
  End: "last",
}

const TOGGLE_KEYS = new Set(["Enter", " ", "ArrowDown", "ArrowUp", "Escape"])

const menuItems = function(menu) {
  return menu.querySelectorAll('a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])')
}

const setExpanded = function(toggle, expanded) {
  toggle.setAttribute("aria-expanded", expanded ? "true" : "false")
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
  menu.addEventListener("keydown", menuKeydown)
  document.addEventListener("click", outsideClick)

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
  menu.classList.remove("block")
  menu.classList.add("hidden")
  menu.removeEventListener("keydown", menuKeydown)
  document.removeEventListener("click", outsideClick)
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

const focusItem = function(menu, direction) {
  const items = Array.from(menuItems(menu))
  if (items.length === 0) { return }

  const index = items.indexOf(document.activeElement)

  if (direction === "first") {
    items[0].focus()
  } else if (direction === "last") {
    items[items.length - 1].focus()
  } else if (direction === "next") {
    items[index < items.length - 1 ? index + 1 : 0].focus()
  } else if (direction === "prev") {
    items[index > 0 ? index - 1 : items.length - 1].focus()
  }
}

const menuKeydown = function(event) {
  if (!activeDropdown) { return }
  if (event.currentTarget !== activeDropdown.menu) { return }

  if (event.key === "Escape") {
    event.preventDefault()
    event.stopPropagation()
    close()
    return
  }

  const dir = FOCUS_DIRECTIONS[event.key]
  if (dir) {
    event.preventDefault()
    focusItem(activeDropdown.menu, dir)
  }
}

const toggleKeydown = function(event) {
  if (!TOGGLE_KEYS.has(event.key)) { return }

  const menu = document.getElementById(this.dataset.dropdownToggle)
  if (!menu) { return }

  if (event.key === "Escape") {
    if (activeDropdown && activeDropdown.menu === menu) {
      event.preventDefault()
      event.stopPropagation()
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
    if (event.key === "ArrowUp") {
      items[items.length - 1].focus()
    } else {
      items[0].focus()
    }
  }
}

const outsideClick = function(event) {
  if (!activeDropdown) { return }
  if (activeDropdown.toggle.contains(event.target)) { return }
  if (activeDropdown.menu.contains(event.target)) { return }
  close()
}

Rails.delegate(document, "[data-dropdown-toggle]", "click", toggleClick)
Rails.delegate(document, "[data-dropdown-toggle]", "keydown", toggleKeydown)
