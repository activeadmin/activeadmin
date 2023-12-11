const nextSibling = function next(element, selector) {
  let sibling = element.nextElementSibling;

  if (!selector) {
    return sibling;
  }

  while (sibling) {
    if (sibling && sibling.matches(selector)) {
      return sibling;
    }

    sibling = sibling.nextElementSibling;
  }
}

export { nextSibling }
