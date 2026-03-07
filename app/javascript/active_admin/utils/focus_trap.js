const FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'

const trapFocus = function(container) {
  const handler = function(event) {
    if (event.key !== "Tab") { return }

    const focusable = [...container.querySelectorAll(FOCUSABLE)].filter(el => el.offsetParent !== null)
    if (focusable.length === 0) { return }

    const first = focusable[0]
    const last = focusable[focusable.length - 1]

    if (event.shiftKey) {
      if (document.activeElement === first) {
        event.preventDefault()
        last.focus()
      }
    } else {
      if (document.activeElement === last) {
        event.preventDefault()
        first.focus()
      }
    }
  }

  container.addEventListener("keydown", handler)

  return function() {
    container.removeEventListener("keydown", handler)
  }
}

const focusFirstDescendant = function(container) {
  const focusable = container.querySelectorAll(FOCUSABLE)
  if (focusable.length > 0) {
    focusable[0].focus()
  }
}

export { trapFocus, focusFirstDescendant, FOCUSABLE }
